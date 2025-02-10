//
//  ProfileViewModel.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 10/02/2025.
//

import Foundation

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var scans: [Scan] = []
    
    private let getUserScansUseCase: GetUserScansUseCaseProtocol
    private let userID: String
    let username: String
    
    init(getUserScansUseCase: GetUserScansUseCaseProtocol, userID: String, username: String) {
        self.getUserScansUseCase = getUserScansUseCase
        self.userID = userID
        self.username = username
    }
    
    /// factory method for safe initialization
    static func create() -> ProfileViewModel {
        let getScansUseCase = GetUserScansUseCase(repository: ScanRepository(apiService: APIService()))
        return .init(getUserScansUseCase: getScansUseCase,
                     userID: LoginManager.userID,
                     username: LoginManager.username)
    }
    
    func fetchScans() async {
        do {
            self.scans = try await getUserScansUseCase.getUserScan(userId: userID)
        } catch {
            print(error.localizedDescription)
        }
    }
}
