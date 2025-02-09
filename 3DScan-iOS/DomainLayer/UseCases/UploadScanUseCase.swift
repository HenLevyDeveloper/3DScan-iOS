//
//  UploadScanUseCase.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

protocol UploadScanUseCaseProtocol {
    func generatePresignedUrl(userId: String, fileName: String) async throws -> PresignedURL
    func uploadScan(_ fileURL: URL, presignedURL: URL) async throws -> Bool
}

class UploadScanUseCase: UploadScanUseCaseProtocol {
    
    private let repository: ScanRepositoryProtocol

    init(repository: ScanRepositoryProtocol) {
        self.repository = repository
    }

    func generatePresignedUrl(userId: String, fileName: String) async throws -> PresignedURL {
        try await repository.generatePresignedUrl(userId: userId, fileName: fileName)
    }
    
    func uploadScan(_ fileURL: URL, presignedURL: URL) async throws -> Bool {
        try await repository.uploadScan(fileURL, presignedURL: presignedURL)
    }
}
