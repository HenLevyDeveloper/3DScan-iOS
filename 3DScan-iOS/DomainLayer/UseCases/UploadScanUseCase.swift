//
//  UploadScanUseCase.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

protocol UploadScanUseCaseProtocol {
    func execute(userId: String, scanFile: Data, fileName: String) async throws -> String
}

class UploadScanUseCase: UploadScanUseCaseProtocol {
    private let repository: ScanRepositoryProtocol

    init(repository: ScanRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String, scanFile: Data, fileName: String) async throws -> String {
        return try await repository.uploadScan(userId: userId, scanFile: scanFile, fileName: fileName)
    }
}
