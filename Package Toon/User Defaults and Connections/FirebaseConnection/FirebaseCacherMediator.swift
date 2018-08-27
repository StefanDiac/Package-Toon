//
//  FirebaseCacherMediator.swift
//  Package Toon
//
//  Created by Air_Book on 6/30/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class FirebaseCacherMediator {
    
    static func loadProfileInformation(forProfileFragment fragment: SocialProfileFragment) {
        if let profileInfo = Cacher.retriveProfileInformationFromCache() {
            fragment.changeFragmentForLoaded(scoreValues: profileInfo.convertScoresDictionaryToArray(), playerName: profileInfo.playerName)
        } else {
            FirebaseDAO.loadProfileDetails(forProfileFragment: fragment)
        }
    }
    
    static func saveProfileInformation(scoreValues: [Int], playerName: String) {
        Cacher.cacheProfileLoadInformation(profileCache: ProfileCache(playerName: playerName, scores: scoreValues))
    }
    
    static func updateProfileName(newProfileName: String) {
        if let profileInfo = Cacher.retriveProfileInformationFromCache() {
            let newProfileCacheInfo = ProfileCache(playerName: newProfileName, scores: profileInfo.scores)
            Cacher.cacheProfileLoadInformation(profileCache: newProfileCacheInfo)
        }
    }
    
    static func updateCachedScoreValue(forGameMode gameMode: String, newScoreValue newScore: Int) {
        if let profileInfo = Cacher.retriveProfileInformationFromCache() {
            var scoresInfo = profileInfo.scores
            scoresInfo[gameMode] = newScore
            Cacher.cacheProfileLoadInformation(profileCache: ProfileCache(playerName: profileInfo.playerName, scores: scoresInfo))
        }
    }
    
    static func loadFriendsInformation(forFriendFragment friendFragment: SocialFriendsFragment) {
        if let friendInfo = Cacher.retriveFriendsInformationFromCache() {
            friendFragment.handleLoadingComplete(withFriendCode: friendInfo.friendCode, withFriends: friendInfo.friends)
        } else {
            FirebaseDAO.loadFriendsDetails(forFriendFragment: friendFragment)
        }
    }
    
    static func saveFriendsInformation(friendCode: String, friends: [(String, String)]) {
        Cacher.cacheFriendsLoadInformation(friendsCache: FriendsCache(friendCode: friendCode, friends: friends))
    }
    
    static func updateCachedFriendsAdding(newFriendAdded newFriend: (String, String)) {
        if let friendInfo = Cacher.retriveFriendsInformationFromCache() {
            var friends = friendInfo.friends
            friends.append(newFriend)
            Cacher.cacheFriendsLoadInformation(friendsCache: FriendsCache.init(friendCode: friendInfo.friendCode, friends: friends))
        }
    }
    
    static func updateCachedFriendsRemoval(friendToRemove friend: String) {
        if let friendInfo = Cacher.retriveFriendsInformationFromCache() {
            var friends = friendInfo.friends
            var friendRemoved = false
            for i in 0..<friends.count {
                if friendRemoved, friends[i].0 == friend {
                    friends.remove(at: i)
                    friendRemoved = true
                }
            }
            Cacher.cacheFriendsLoadInformation(friendsCache: FriendsCache(friendCode: friendInfo.friendCode, friends: friends))
        }
    }
}
