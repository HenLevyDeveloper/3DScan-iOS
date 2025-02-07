//
//  ScanViewModel.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

@MainActor
class ScanViewModel: ObservableObject {
    @Published var uploadStatus: ScanUploadStatus = .idle
    
    var isUploadDisabled: Bool {
        switch uploadStatus {
        case .ready(let URL):
            return false
        default:
            return true
        }
    }
    
    private var scanFileURL: URL?
    
    private let uploadScanUseCase: UploadScanUseCaseProtocol

    private init(uploadScanUseCase: UploadScanUseCaseProtocol) {
        self.uploadScanUseCase = uploadScanUseCase
    }

    /// Factory method for async-safe initialization
    static func create() async -> ScanViewModel {
        let apiService = APIService()
        let repository = ScanRepository(apiService: apiService)
        let useCase = UploadScanUseCase(repository: repository)
        return ScanViewModel(uploadScanUseCase: useCase)
    }

    func setScanning() {
        self.uploadStatus = .scanning
    }

    func setScanFile(_ fileURL: URL?) {
        guard let fileURL = fileURL else {
            self.uploadStatus = .failure("Scan failed")
            return
        }
        
        self.scanFileURL = fileURL
        self.uploadStatus = .ready(fileURL)
    }

    func uploadScan() async {
        guard let scanFileURL = scanFileURL, let scanData = try? Data(contentsOf: scanFileURL) else {
            self.uploadStatus = .failure("No scan available")
            return
        }

        self.uploadStatus = .uploading

        do {
            let scanUrl = try await uploadScanUseCase.execute(userId: "USER_ID_HERE", scanFile: scanData, fileName: scanFileURL.lastPathComponent)
            self.uploadStatus = .success(scanUrl)
        } catch {
            self.uploadStatus = .failure(error.localizedDescription)
        }
    }
}
