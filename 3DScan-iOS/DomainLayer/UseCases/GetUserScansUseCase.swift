//
//  Untitled.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 09/02/2025.
//



import Foundation

protocol GetUserScansUseCaseProtocol {
    func getUserScan(userId: String) async throws -> [Scan]
    func getViewPresignedURL(userId: String, fileKey: String) async throws -> URL
}

class GetUserScansUseCase: GetUserScansUseCaseProtocol {
    private let repository: ScanRepositoryProtocol

    init(repository: ScanRepositoryProtocol) {
        self.repository = repository
    }

    func getUserScan(userId: String) async throws -> [Scan] {
        try await repository.getUserScans(userId: userId)
    }
    
    func getViewPresignedURL(userId: String, fileKey: String) async throws -> URL {
        try await repository.getViewPresignedURL(userId: userId, fileKey: fileKey)
    }
}
