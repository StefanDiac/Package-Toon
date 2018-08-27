//
//  Cacher.swift
//  Package Toon
//
//  Created by Air_Book on 6/30/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class Cacher {
    
    static func cacheProfileLoadInformation(profileCache: ProfileCache) {
        let cache = GameViewController.playerInfoCacheReference
        cache.setObject(profileCache, forKey: "profile")
    }
    
    static func retriveProfileInformationFromCache() -> ProfileCache? {
        let cache = GameViewController.playerInfoCacheReference
        return cache.object(forKey: "profile")
    }
    
    static func cacheFriendsLoadInformation(friendsCache: FriendsCache) {
        let cache = GameViewController.friendsCacheReference
        cache.setObject(friendsCache, forKey: "friends")
    }
    
    static func retriveFriendsInformationFromCache() -> FriendsCache? {
        let cache = GameViewController.friendsCacheReference
        return cache.object(forKey: "friends")
    }
}
