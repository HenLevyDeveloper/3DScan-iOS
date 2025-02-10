//
//  PersistentManager.swift
//  3DScan-iOS
//
//  Created by Hen Levi on 07/02/2025.
//

import Foundation

class PersistentManager {
    
    static func getAuthToken() -> String? {
        return UserDefaults.standard.string(forKey: "authToken")
    }
    
    static func setAuthToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: "authToken") // TODO: This should be moved to keychain for encryption
    }
    
    static func getUserID() -> String? {
        return UserDefaults.standard.string(forKey: "userId")
    }
    
    static func setUserID(_ userID: String) {
        UserDefaults.standard.set(userID, forKey: "userId")
    }
    
    static func getUserName() -> String? {
        return UserDefaults.standard.string(forKey: "userName")
    }
    
    static func setUserName(_ userName: String) {
        UserDefaults.standard.set(userName, forKey: "userName")
    }
}
