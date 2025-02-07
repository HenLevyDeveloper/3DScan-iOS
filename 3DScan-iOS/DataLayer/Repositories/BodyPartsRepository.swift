//
//  BodyPartsRepository.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import Foundation

protocol BodyPartsRepositoryProtocol {
    func fetchBodyParts() async throws -> [BodyPart]
}

class BodyPartsRepository: BodyPartsRepositoryProtocol {
    private let apiService: APIService
    
    init(apiService: APIService) {
        self.apiService = apiService
    }
    
    func fetchBodyParts() async throws -> [BodyPart] {
        let response = try await apiService.request(.getBodyParts)
        return try JSONDecoder().decode([BodyPart].self, from: response.data)
    }
}

