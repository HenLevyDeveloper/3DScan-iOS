//
//  LoginManager.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

class LoginManager {
    static var isLoggedIn: Bool {
        PersistentManager.getAuthToken() != nil
    }
    static var userID: String {
        PersistentManager.getUserID() ?? ""
    }
    static var username: String {
        PersistentManager.getUserName() ?? ""
    }
}
