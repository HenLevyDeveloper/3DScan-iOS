//
//  ModelViewerViewModel.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 10/02/2025.
//

import SwiftUI

@MainActor
class ModelViewerViewModel: ObservableObject {
    enum Mode {
        case localFile(url: URL)
        case externalFile(userId: String, fileKey: String)
    }
    
    @Published var localFileURL: URL?
    @Published var isLoading = true
    @Published var errorMessage: String?

    private let userScansUseCase: GetUserScansUseCaseProtocol
    private var userId: String = ""
    private var fileKey: String = ""
    
    private init(mode: Mode, userScansUseCase: GetUserScansUseCaseProtocol) {
        self.userScansUseCase = userScansUseCase
        
        switch mode {
        case .localFile(let url):
            localFileURL = url
        case .externalFile(let userId, let fileKey):
            self.userId = userId
            self.fileKey = fileKey
        }
    }
    
    static func create(withLocalFileURL url: URL) -> ModelViewerViewModel {
        let useCase = GetUserScansUseCase(repository: ScanRepository(apiService: APIService()))
        return .init(mode: .localFile(url: url), userScansUseCase: useCase)
    }
    
    static func create(withExternalFileKey fileKey: String, userId: String) -> ModelViewerViewModel {
        let useCase = GetUserScansUseCase(repository: ScanRepository(apiService: APIService()))
        let filename = fileKey.components(separatedBy: "/").last ?? ""
        return .init(mode: .externalFile(userId: userId, fileKey: filename),
                     userScansUseCase: useCase)
    }
    
    // If I want to view a private scan file in S3 - I need to generate a presigned url to view it
    func fetchViewPersignedURL() async {
        do {
            let presignedUrl = try await userScansUseCase.getViewPresignedURL(userId: userId, fileKey: fileKey)
            await downloadModel(from: presignedUrl)
        } catch {
            print("❌ Error fetching pre-signed URL:", error.localizedDescription)
            self.errorMessage = "Failed to get pre-signed URL"
            self.isLoading = false
        }
    }

    // SCNScene can only load from local file url, so if it's an external url -
    // needs to download and save it first to a local file url
    private func downloadModel(from url: URL) async {
        let fileName = url.lastPathComponent
        let localURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            try data.write(to: localURL)
            self.localFileURL = localURL
        } catch {
            print("❌ Error downloading model:", error.localizedDescription)
            self.errorMessage = "Download failed"
        }

        self.isLoading = false
    }
}
