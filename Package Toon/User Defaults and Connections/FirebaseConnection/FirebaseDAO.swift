//
//  FirebaseDAO.swift
//  Package Toon
//
//  Created by Air_Book on 6/21/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import FacebookCore
import SpriteKit
import UIKit

class FirebaseDAO {
    static func handleRegisterEvent(registerType: AuthentificationType, token: Any, fromRegisterFragment fragment: SocialRegisterFragment) {
        switch registerType {
        case .facebook:
            if let castedToken = token as? AccessToken {
                handleFacebookRegister(accessToken: castedToken, fromRegisterFragment: fragment)
            }
            break;
        case .google:
            break;
        case .twitter:
            break;
        }
    }
    
    private static func handleFacebookRegister(accessToken: AccessToken, fromRegisterFragment fragment: SocialRegisterFragment) {
        let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.authenticationToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            let databaseReference = Database.database().reference()
            let uid = authResult!.user.uid
            UserDefaultsSettingsManager.saveAuthentificationToken(token: nil, authType: .facebook)
            checkForAlreadyExistingCollision(databaseReference: databaseReference, uid: uid, registerFragmentToUpdate: fragment, completion: {
                addUserToDatabase(databaseReference: databaseReference, uid: uid)
                databaseReference.child("users").child(uid).child("friends").child("Friend ID").setValue(UserDefaultsSettingsManager.getFriendUID()!)
                fragment.handleLoginFinished()
            })
        }
    }
    
    private static func checkForAlreadyExistingCollision(databaseReference: DatabaseReference, uid: String, registerFragmentToUpdate fragment: SocialRegisterFragment, completion: @escaping ()->()) {
        
        databaseReference.child("users").queryOrderedByKey().queryEqual(toValue: uid).observeSingleEvent(of: .value) { (snapshot) in
            let values = snapshot.value as? NSDictionary
            let userInfo = values!["\(uid)"] as? NSDictionary
            if let _ = userInfo {
                fragment.handleLoginFinished()
            } else {
                completion()
            }
        }
    }
    
    private static func handleGoogleRegister() {
        
    }
    
    private static func handleTwitterRegister() {
        
    }
    
    private static func addUserToDatabase(databaseReference: DatabaseReference, uid: String) {
        databaseReference.child("users").child(uid).child("Display Name").setValue("Bunny Dancer")
        
        GAME_IDENTIFIERS_STRING_LITERALS.forEach {
            databaseReference.child("users").child(uid).child("Scores").child($0).setValue(0)
        }
        databaseReference.child("users").child(uid).child("friends").child("Friends").setValue("")
        UserDefaultsSettingsManager.saveQuickLoginDetails(uid: uid)
    }
    
    static func storeNewHighScore(scoreValue: Int, gameMode: String) {
        if let credential = getAuthCredentials() {
            saveNewHighScore(scoreValue: scoreValue, gameMode: gameMode, credentials: credential)
        } else {
            print("User has not registered")
        }
    }
    
    static func removeFriend(withCode code: String, forTableToUpdate table: FriendsTableView) {
        if let credentials = getAuthCredentials() {
            removeFriendFromDatabase(credentials: credentials, friendCode: code, tableViewToUpdate: table)
        }
    }
    
    private static func removeFriendFromDatabase(credentials: AuthCredential, friendCode: String, tableViewToUpdate tableView: FriendsTableView) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print("Was unable to remove friend. \(error)")
                return
            }
            let uid = authResult!.user.uid
            let databaseReference = Database.database().reference()
            
            databaseReference.child("users/\(uid)/friends").observeSingleEvent(of: .value, with: { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let friends = values?["Friends"] as? String
                if let friendString = friends {
                    let friendsArray = friendString.split(separator: ",")
                    let newFriendString = removeFriendFromFriendsArray(friendCode: friendCode, friendsArray: friendsArray)
                    print(newFriendString)
                    databaseReference.child("users/\(uid)/friends/Friends").setValue(newFriendString)
                    tableView.removeFriend(withCode: friendCode)
                    FirebaseCacherMediator.updateCachedFriendsRemoval(friendToRemove: friendCode)
                }
            })
        }
    }
    
    private static func removeFriendFromFriendsArray(friendCode: String, friendsArray: [Substring]) -> String {
        var recombinedString = ""
        for i in 0..<friendsArray.count {
            if String(friendsArray[i]) != friendCode {
                recombinedString.append("\(friendsArray[i]),")
            }
        }
        return String(recombinedString.dropLast())
    }
    
    private static func saveNewHighScore(scoreValue: Int, gameMode: String, credentials: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print(error)
                return
            }
            let databaseReference = Database.database().reference()
            let uid = authResult!.user.uid
            databaseReference.child("users/\(uid)/Scores/\(gameMode)").setValue(scoreValue)
            FirebaseCacherMediator.updateCachedScoreValue(forGameMode: gameMode, newScoreValue: scoreValue)
        }
    }
    
    static func loadProfileDetails(forProfileFragment fragment: SocialProfileFragment) {
        if let credential = getAuthCredentials() {
            getProfileDetails(profileFragment: fragment, credentials: credential)
        } else {
            fragment.changeFragmentForError()
        }
    }
    
    static func loadFriendsDetails(forFriendFragment fragment: SocialFriendsFragment) {
        if let credential = getAuthCredentials() {
            getFriendsDetails(forCredentials: credential, friendsFragment: fragment)
        } else {
            fragment.handleLoadingError()
        }
    }
    
    static func changeUserDisplayName(profileFragment: SocialProfileFragment?, newDisplayName name: String) -> Bool {
        if let credential = getAuthCredentials() {
            changeDisplayNameEntry(profileFragment: profileFragment, newDisplayName: name, credentials: credential)
            return true
        } else {
            return false
        }
    }
    
    static func attemptToAddFriend(friendCode: String, withUpdatingFragment fragment: SocialFriendsFragment) {
        if let credentials = getAuthCredentials() {
            attemptFriendFinding(withCredentials: credentials, forCode: friendCode, updatingFragment: fragment)
        }
    }
    
    static func retriveOnlineScores(withCompletionHandler completion: @escaping ([(NSDictionary, String)]?) -> ()) {
        if let credentials = getAuthCredentials() {
            downloadScores(forCredentials: credentials, withCompletionHandler: completion)
        }
    }
    
    private static func downloadScores(forCredentials credentials: AuthCredential, withCompletionHandler completion: @escaping ([(NSDictionary, String)]?) -> ()) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print("Was unable to download scores from Firebase ! \(error)")
                completion(nil)
                return
            }
            let uid = authResult!.user.uid
            let databaseReference = Database.database().reference()
            
            databaseReference.child("users/\(uid)/friends").observeSingleEvent(of: .value, with: { (snapshot) in
                let friendValues = snapshot.value as? NSDictionary
                let friendsString = friendValues?["Friends"] as? String
                if let friends = friendsString {
                    var friendsAsString = [String]()
                    let friendsSeparated = friends.split(separator: ",")
                    friendsSeparated.forEach({ (substring) in
                        friendsAsString.append(String(substring))
                        })
                    downloadFriendScores(friendCodes: friendsAsString, ownUID: uid, databaseReference: databaseReference, completion: completion)
                }
            })
        }
    }
    private static func downloadFriendScores(friendCodes: [String],  ownUID: String, databaseReference: DatabaseReference, completion: @escaping ([(NSDictionary, String)]?) -> ()) {
        var friendScoresAndNames = [(NSDictionary, String)]()
        let dispatchGroup = DispatchGroup()
        friendCodes.forEach { (friendCode) in
            dispatchGroup.enter()
            databaseReference.child("users").queryOrdered(byChild: "friends/Friend ID").queryEqual(toValue: friendCode).observeSingleEvent(of: .value, with: { (snapshot) in
                let userDetails = snapshot.value as? NSDictionary
                if let user = userDetails {
                    let uid = user.allKeys.first as! String
                    let userDetails = user[uid] as! NSDictionary
                    let friendScores = userDetails["Scores"] as! NSDictionary
                    let friendDisplayName = userDetails["Display Name"] as! String
                    friendScoresAndNames.append((friendScores, friendDisplayName))
                    dispatchGroup.leave()
                }
            })
        }
        dispatchGroup.enter()
        databaseReference.child("users/\(ownUID)").observeSingleEvent(of: .value, with: { (snapshot) in
            let userValues = snapshot.value as? NSDictionary
            if let userData = userValues {
                let userDisplayName = userData["Display Name"] as? String ?? "You"
                let userScores = userData["Scores"] as! NSDictionary
                friendScoresAndNames.append((userScores, userDisplayName))
                dispatchGroup.leave()
            }
        })
        dispatchGroup.notify(queue: .main) {
            completion(friendScoresAndNames)
        }
    }
    
    private static func attemptFriendFinding(withCredentials credentials: AuthCredential, forCode code: String, updatingFragment fragment: SocialFriendsFragment) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print(error)
                fragment.handleLabelUpdateForNoConnection()
                return
            }
            
            let uid = authResult!.user.uid
            let databaseReference = Database.database().reference()
            findFriend(forFriendCode: code, databaseReference: databaseReference, completion: { (snapshot) in
                if snapshot.childrenCount != 0 {
                    addNewFriend(forUserWithUid: uid, friendCode: code, databaseReference: databaseReference, fragmentToUpdate: fragment)
                } else {
                    fragment.handleFriendCodeNotFound()
                }
            })
        }
    }
    
    private static func findFriend(forFriendCode code: String, databaseReference: DatabaseReference, completion: @escaping (DataSnapshot) -> Void) {
        databaseReference.child("users").queryOrdered(byChild: "friends/Friend ID").queryEqual(toValue: code).observeSingleEvent(of: .value) { (snapshot) in
            completion(snapshot)
        }
    }
    
    private static func addNewFriend(forUserWithUid uid: String, friendCode code: String, databaseReference: DatabaseReference, fragmentToUpdate: SocialFriendsFragment) {
        databaseReference.child("users/\(uid)/friends").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            
            var friends = value?["Friends"] as? String ?? ""
            var canAdd: Bool = true
            
            if friends.count != 0 {
                if checkForFriendCollision(friendCode: code, friends: friends) {
                    fragmentToUpdate.handleFriendCollisionFound()
                    canAdd = false
                } else {
                    friends.append(",\(code)")
                }
            } else {
                friends.append(code)
            }
            if canAdd {
                let friendAsSingleArray = [code]
                getAllDisplayNames(forFriendCodes: friendAsSingleArray, databaseReference: databaseReference, completion: { (friendAndDisplay) in
                    FirebaseCacherMediator.updateCachedFriendsAdding(newFriendAdded: friendAndDisplay.first!)
                    databaseReference.child("users/\(uid)/friends/Friends").setValue(friends)
                    fragmentToUpdate.addFriendToTable(friendCodeAndName: friendAndDisplay.first!)
                    fragmentToUpdate.handleLabelUpdateForSuccess()
                })
            }
            }) {(error) in
                print(error)
                fragmentToUpdate.handleLabelUpdateForNoConnection()
        }
    }
    
    private static func checkForFriendCollision(friendCode: String, friends: String) -> Bool {
        if friends.localizedStandardContains(friendCode) {
            return true
        } else {
            return false
        }
    }
    
    private static func getAuthCredentials() -> AuthCredential? {
        let loginType = UserDefaultsSettingsManager.getLoginType()
        var credential: AuthCredential?
        if let type = loginType {
            switch type {
            case .facebook:
                let accessToken = FacebookLoginManager.retriveAccessToken()
                if let token = accessToken {
                    credential = FacebookAuthProvider.credential(withAccessToken: token.authenticationToken)
                } else {
                    print("Could not connect to firebase, no token")
                }
                break;
            case .google:
                break;
            case .twitter:
                break;
            }
        }
        return credential
    }
    
    private static func getFriendsDetails(forCredentials credentials: AuthCredential, friendsFragment: SocialFriendsFragment) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print(error)
                friendsFragment.handleLoadingError()
            }
            
            let uid = authResult!.user.uid
            let databaseReference = Database.database().reference()
            
            databaseReference.child("users/\(uid)/friends").observeSingleEvent(of: .value, with: { (snapshot) in
                var friends = [String]()
                let values = snapshot.value as? NSDictionary
                let allFriendsString = values?["Friends"] as? String ?? ""
                if allFriendsString != "" {
                   let friendsSubstrings = allFriendsString.split(separator: ",")
                    friendsSubstrings.forEach({
                        friends.append(String($0))
                    })
                }
                let friendCode = values?["Friend ID"] as? String ?? "#Error"
                getAllDisplayNames(forFriendCodes: friends, databaseReference: databaseReference, completion: {(friendsWithDisplayNames) in
                    FirebaseCacherMediator.saveFriendsInformation(friendCode: friendCode, friends: friendsWithDisplayNames)
                    if checkIfFragmentUpdateIsStillPossible(fragment: friendsFragment) {
                        friendsFragment.handleLoadingComplete(withFriendCode: friendCode, withFriends: friendsWithDisplayNames)
                    }
                })
            })
        }
    }
    
    private static func getAllDisplayNames(forFriendCodes codes: [String], databaseReference: DatabaseReference, completion: @escaping ([(String, String)])->Void) {
        var friendsWithDisplayName = [(String, String)]()
        let dispatchGroup = DispatchGroup()
        codes.forEach { (code) in
            dispatchGroup.enter()
            findFriend(forFriendCode: code, databaseReference: databaseReference, completion: { (snapshot) in
                let values = snapshot.value as? NSDictionary
                let uid = values?.allKeys.first as? String ?? ""
                let nestedValues = values?[uid] as? NSDictionary
                let displayName = nestedValues?["Display Name"] as? String ?? "Player"
                friendsWithDisplayName.append((code, displayName))
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(friendsWithDisplayName)
        }
    }
    
    private static func changeDisplayNameEntry(profileFragment: SocialProfileFragment?, newDisplayName name: String, credentials: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print(error)
                profileFragment?.restoreNameInCaseOfNoConnetion()
                return
            }
            profileFragment?.playerName = name
            FirebaseCacherMediator.updateProfileName(newProfileName: name)
            let databaseReference = Database.database().reference()
            let uid = authResult!.user.uid
            databaseReference.child("users/\(uid)/Display Name").setValue(name)
        }
    }
    
    private static func getProfileDetails(profileFragment: SocialProfileFragment, credentials: AuthCredential) {
        Auth.auth().signInAndRetrieveData(with: credentials) { (authResult, error) in
            if let error = error {
                print(error)
                profileFragment.changeFragmentForError()
                return
            }
            
            let databaseReference = Database.database().reference()
            let uid = authResult!.user.uid
            
            databaseReference.child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
                var scores = [Int]()
                let value = snapshot.value as? NSDictionary
                let scoresDictionary = value?["Scores"] as? NSDictionary
                if let dictionary = scoresDictionary {
                    let discoScore = dictionary[GAME_IDENTIFIERS_STRING_LITERALS[0]] as? Int ?? 0
                    let rushScore = dictionary[GAME_IDENTIFIERS_STRING_LITERALS[1]] as? Int ?? 0
                    let fiveRushScore = dictionary[GAME_IDENTIFIERS_STRING_LITERALS[2]] as? Int ?? 0
                    scores.append(contentsOf: [  discoScore, rushScore, fiveRushScore])
                } else {
                    scores.append(contentsOf: [0,0,0])
                }
                let displayName = value?["Display Name"] as? String ?? ""
                FirebaseCacherMediator.saveProfileInformation(scoreValues: scores, playerName: displayName)
                if checkIfFragmentUpdateIsStillPossible(fragment: profileFragment) {
                    profileFragment.changeFragmentForLoaded(scoreValues: scores, playerName: displayName)
                }
            }) { (error) in print(error.localizedDescription)
                profileFragment.changeFragmentForError()
            }
        }
    }
    
    private static func checkIfFragmentUpdateIsStillPossible(fragment: FragmentBase) -> Bool{
        if let scene = fragment.callerScene as? MenuScene {
            if let displayedFragment = scene.displayedFragment as? FragmentBase, displayedFragment == fragment {
                return true
            }
        }
        return false
    }
}
