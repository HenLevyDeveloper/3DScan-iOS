//
//  AuthRepository.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import Foundation

protocol AuthRepositoryProtocol {
    func login(email: String, password: String) async throws -> User
    func register(name: String, email: String, password: String) async throws -> User
}

class AuthRepository: AuthRepositoryProtocol {
    private let apiService: APIService

    init(apiService: APIService) {
        self.apiService = apiService
    }

    func login(email: String, password: String) async throws -> User {
        let response = try await apiService.request(.login(email: email, password: password))
        let user = try JSONDecoder().decode(User.self, from: response.data)
        if let token = user.token {
            PersistentManager.setAuthToken(token)
        }
        PersistentManager.setUserID(user.id)
        PersistentManager.setUserName(user.name)
        return user
    }
    
    func register(name: String, email: String, password: String) async throws -> User {
        let response = try await apiService.request(.register(name: name, email: email, password: password))
        return try JSONDecoder().decode(User.self, from: response.data)
    }
}
