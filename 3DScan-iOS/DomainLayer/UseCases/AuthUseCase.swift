//
//  AuthUseCase.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//


protocol AuthUseCaseProtocol {
    func login(email: String, password: String) async throws -> User
    func register(name: String, email: String, password: String) async throws -> User
}

class AuthUseCase: AuthUseCaseProtocol {
    private let repository: AuthRepositoryProtocol

    init(repository: AuthRepositoryProtocol) {
        self.repository = repository
    }

    func login(email: String, password: String) async throws -> User {
        return try await repository.login(email: email, password: password)
    }
    
    func register(name: String, email: String, password: String) async throws -> User {
        return try await repository.register(name: name, email: email, password: password)
    }
}
