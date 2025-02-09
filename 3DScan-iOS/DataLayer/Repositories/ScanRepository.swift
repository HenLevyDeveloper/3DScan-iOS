//
//  ScanRepository.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

protocol ScanRepositoryProtocol {
    func generatePresignedUrl(userId: String, fileName: String) async throws -> PresignedURL
    func getUserScans(userId: String) async throws -> [Scan]
    func uploadScan(_ fileURL: URL, presignedURL: URL) async throws -> Bool
}

class ScanRepository: ScanRepositoryProtocol {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func generatePresignedUrl(userId: String, fileName: String) async throws -> PresignedURL {
        let response = try await apiService.request(.generateScanPresignedUrl(userId: userId, fileName: fileName))
        return try JSONDecoder().decode(PresignedURL.self, from: response.data)
    }
    
    func getUserScans(userId: String) async throws -> [Scan] {
        let response = try await apiService.request(.getUserScans(userId: userId))
        return try JSONDecoder().decode([Scan].self, from: response.data)
    }
    
    func uploadScan(_ fileURL: URL, presignedURL: URL) async throws -> Bool {
        let response = try await apiService.request(.upload(fileURL: fileURL, presignedURL: presignedURL))
        return response.statusCode == 200
    }
}
