//
//  ScanRepository.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

protocol ScanRepositoryProtocol {
    func uploadScan(userId: String, scanFile: Data, fileName: String) async throws -> String
}

class ScanRepository: ScanRepositoryProtocol {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func uploadScan(userId: String, scanFile: Data, fileName: String) async throws -> String {
        let response = try await apiService.uploadScan(userId: userId, scanFile: scanFile, fileName: fileName)
        let json = try JSONDecoder().decode([String: String].self, from: response.data)
        return json["scanUrl"] ?? ""
    }
}
