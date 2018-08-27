//
//  FriendsCache.swift
//  Package Toon
//
//  Created by Air_Book on 6/30/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class FriendsCache {
    private let _friendCode: String
    private let _friends: [(String,String)]
    
    var friendCode: String {
        get {
            return _friendCode
        }
    }
    var friends: [(String,String)] {
        get {
            return _friends
        }
    }
    
    init(friendCode: String, friends: [(String,String)]) {
        _friends = friends
        _friendCode = friendCode
    }
}
