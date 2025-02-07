//
//  ProductsUseCase.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//


protocol ProductsUseCaseProtocol {
    func execute() async throws -> [ProductSolution]
}

class ProductsUseCase: ProductsUseCaseProtocol {
    private let repository: ProductsRepositoryProtocol
    
    init(repository: ProductsRepositoryProtocol) {
        self.repository = repository
    }
    
    func execute() async throws -> [ProductSolution] {
        return try await repository.fetchProductsSolutions()
    }
}
