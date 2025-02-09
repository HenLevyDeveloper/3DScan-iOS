//
//  Untitled.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 09/02/2025.
//



import Foundation

protocol GetUserScansUseCaseProtocol {
    func execute(userId: String) async throws -> [Scan]
}

class GetUserScansUseCase: GetUserScansUseCaseProtocol {
    private let repository: ScanRepositoryProtocol

    init(repository: ScanRepositoryProtocol) {
        self.repository = repository
    }

    func execute(userId: String) async throws -> [Scan] {
        try await repository.getUserScans(userId: userId)
    }
}
