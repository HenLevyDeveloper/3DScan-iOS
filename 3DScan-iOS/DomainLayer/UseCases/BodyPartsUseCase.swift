//
//  BodyPartsUseCase.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

protocol BodyPartsUseCaseProtocol {
    func execute() async throws -> [BodyPart]
}

class BodyPartsUseCase: BodyPartsUseCaseProtocol {
    private let repository: BodyPartsRepositoryProtocol
    
    init(repository: BodyPartsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [BodyPart] {
        return try await repository.fetchBodyParts()
    }
}
