//
//  HomeViewModel.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import Foundation

@MainActor
class HomeViewModel: ObservableObject {
    @Published var solutions = [ProductSolution]()
    @Published var isLoadingSolutions = false
    @Published var errorMessageSolutions: String?
    
    private let productsUseCase: ProductsUseCaseProtocol
    private init(productsUseCase: ProductsUseCaseProtocol) {
        self.productsUseCase = productsUseCase
    }

    /// factory method for safe initialization
    static func create() -> HomeViewModel {
        let apiService = APIService()
        let repository = ProductsRepository(apiService: apiService)
        let useCase = ProductsUseCase(repository: repository)
        return HomeViewModel(productsUseCase: useCase)
    }

    func fetchSolutions() async {
        isLoadingSolutions = true
        errorMessageSolutions = nil

        do {
            self.solutions = try await productsUseCase.execute()
        } catch {
            errorMessageSolutions = error.localizedDescription
        }

        isLoadingSolutions = false
    }
}
