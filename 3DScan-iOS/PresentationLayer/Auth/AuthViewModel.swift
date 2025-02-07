//
//  AuthViewModel.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 05/02/2025.
//

import SwiftUI

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var errorMessage: String?

    private let authUseCase: AuthUseCaseProtocol

    private init(authUseCase: AuthUseCaseProtocol) {
        self.authUseCase = authUseCase
    }

    /// factory method for safe initialization
    static func create() -> AuthViewModel {
        let apiService = APIService()
        let repository = AuthRepository(apiService: apiService)
        let useCase = AuthUseCase(repository: repository)
        return AuthViewModel(authUseCase: useCase)
    }

    func login(email: String, password: String) async {
        do {
            _ = try await authUseCase.login(email: email, password: password)
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
    
    func register(name: String, email: String, password: String) async {
        do {
            _ = try await authUseCase.register(name: name, email: email, password: password)
            self.isAuthenticated = true
        } catch {
            self.errorMessage = error.localizedDescription
        }
    }
}
