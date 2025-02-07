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
    @Published var bodyParts = [BodyPart]()
    
    private let productsUseCase: ProductsUseCaseProtocol
    private let bodyPartsUseCase: BodyPartsUseCaseProtocol
    
    private init(productsUseCase: ProductsUseCaseProtocol,
                 bodyPartsUseCase: BodyPartsUseCaseProtocol) {
        self.productsUseCase = productsUseCase
        self.bodyPartsUseCase = bodyPartsUseCase
    }

    /// factory method for safe initialization
    static func create() -> HomeViewModel {
        let productsUseCase = ProductsUseCase(repository: ProductsRepository(apiService: APIService()))
        let bodyPartsUseCase = BodyPartsUseCase(repository: BodyPartsRepository(apiService: APIService()))
        return .init(productsUseCase: productsUseCase, bodyPartsUseCase: bodyPartsUseCase)
    }

    func fetchSolutions() async {
        do {
            self.solutions = try await productsUseCase.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchBodyParts() async {
        do {
            self.bodyParts = try await bodyPartsUseCase.execute()
        } catch {
            print(error.localizedDescription)
        }
    }
}
