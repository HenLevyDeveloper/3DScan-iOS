//
//  ScanViewModel.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI
import Combine

@MainActor
class ScanViewModel: ObservableObject {
    
    enum ScanStatus: Equatable {
        case scanning,
             proccesing(progress: Double),
             uploading(progress: Double),
             done(outputModelURL: URL?)
    }
    
    @Published var status: ScanStatus = .scanning
    
    @Published private(set) var isCapturing = false
    @Published private(set) var scanProgress = 0.0
    
    private var scanCompletionCancellable: AnyCancellable?
    private var modelProcessingCancellable: AnyCancellable?
    
    private let uploadScanUseCase: UploadScanUseCaseProtocol
    private let captureService: CaptureServiceProtocol
    
    init(uploadScanUseCase: UploadScanUseCaseProtocol,
         captureService: CaptureServiceProtocol) {
        self.uploadScanUseCase = uploadScanUseCase
        self.captureService = captureService
        
        subscribeToScanCompletion()
    }
    
    /// Factory method for safe initialization
    static func create() -> ScanViewModel {
        let repository = ScanRepository(apiService: APIService())
        let useCase = UploadScanUseCase(repository: repository)
        return .init(uploadScanUseCase: useCase,
                     captureService: CaptureService())
    }
    
    private func subscribeToScanCompletion() {
        scanCompletionCancellable = captureService.scanCompletionPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] scanProgress in
                guard let self = self else { return }
                self.scanProgress = scanProgress
                
                if scanProgress >= 1.0 {
                    self.status = .proccesing(progress: 0)
                    self.scanCompletionCancellable?.cancel()
                    self.scanCompletionCancellable = nil
                    self.subscribeToModelProcessing()
                } else {
                    self.status = .scanning
                }
            }
    }
    
    private func subscribeToModelProcessing() {
        modelProcessingCancellable = captureService.modelProcessingPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] progress in
                guard let self = self else { return }
                self.status = .proccesing(progress: progress)
                
                if progress >= 1.0, let outputModelURL = captureService.outputModelURL {
                    self.modelProcessingCancellable?.cancel()
                    self.modelProcessingCancellable = nil
                    
                    self.status = .uploading(progress: progress)
                    Task {
                        await self.generatePresignedURL(outputModelURL: outputModelURL)
                    }
                }
            }
    }
    
    private func generatePresignedURL(outputModelURL: URL) async {
        do {
            let presignedURL = try await uploadScanUseCase.generatePresignedUrl(userId: "67a4c07d8d7db26fb9e7324c",
                                                                                fileName: captureService.fileName)
            if let uploadURL = URL(string: presignedURL.uploadUrl) {
                await uploadScan(outputModelURL: outputModelURL, uploadURL: uploadURL)
            }
        } catch {
            print(error.localizedDescription)
            self.status = .done(outputModelURL: outputModelURL)
        }
    }
    
    private func uploadScan(outputModelURL: URL, uploadURL: URL) async {
        do {
            _ = try await uploadScanUseCase.uploadScan(outputModelURL, presignedURL: uploadURL)
            self.status = .done(outputModelURL: outputModelURL)
        } catch {
            print(error.localizedDescription)
            self.status = .done(outputModelURL: outputModelURL)
        }
    }
    
    func getCaptureService() -> CaptureServiceProtocol {
        return captureService
    }
    
    func toggleCapture() {
        if captureService.isCapturing {
            captureService.stopCapturing()
            isCapturing = false
        } else {
            captureService.startCapturing()
            isCapturing = true
        }
    }
    
    deinit {
        self.scanCompletionCancellable?.cancel()
        self.scanCompletionCancellable = nil

        self.modelProcessingCancellable?.cancel()
        self.modelProcessingCancellable = nil
    }
}
