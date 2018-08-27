//
//  UserDefaultSettingsRetriver.swift
//  Package Toon
//
//  Created by Air_Book on 6/20/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class UserDefaultsSettingsManager {
   
    static func saveQuickLoginDetails(uid: String) {
        let defaults = UserDefaults.standard
        defaults.set(uid, forKey: "loginUID")
        let friendUID = generateFriendsCode()
        defaults.set(friendUID, forKey: "friendCode")
    }
    
    private static func generateFriendsCode() -> String {
        let friendsUUIDFull = UUID().uuidString
        let friendsUUIDSections = friendsUUIDFull.split(separator: "-")
        let friendsUUID = friendsUUIDSections.first!
        return String(friendsUUID)
    }
    
    static func checkForLoginDetailsExistance() -> Bool {
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "authType") {
            return true
        }
        return false
    }
    
    static func saveAuthentificationToken(token: String?, authType: AuthentificationType) {
        let defaults = UserDefaults.standard
        if let authToken = token {
            defaults.set(authToken, forKey: "authToken")
        }
        defaults.set(authType.typeToString(), forKey: "authType")
    }
    
    static func getFriendUID() -> String? {
        return UserDefaults.standard.string(forKey: "friendCode")
    }
    
    static func getUserUID() -> String? {
        return UserDefaults.standard.string(forKey: "loginUID")
    }
    
    static func getLoginType() -> AuthentificationType? {
        return AuthentificationType.typeFromString(type: UserDefaults.standard.string(forKey: "authType"))
    }
}
