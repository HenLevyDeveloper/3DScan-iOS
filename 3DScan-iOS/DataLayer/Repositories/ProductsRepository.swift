//
//  ProductsRepository.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import Foundation

protocol ProductsRepositoryProtocol {
    func fetchProductsSolutions() async throws -> [ProductSolution]
}

class ProductsRepository: ProductsRepositoryProtocol {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func fetchProductsSolutions() async throws -> [ProductSolution] {
        let response = try await apiService.request(.getProductsSolutions)
        return try JSONDecoder().decode([ProductSolution].self, from: response.data)
    }
}
