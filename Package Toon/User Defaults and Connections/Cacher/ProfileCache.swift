//
//  ProfileCache.swift
//  Package Toon
//
//  Created by Air_Book on 6/30/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class ProfileCache {
    private let _playerName: String
    private let _scores: [String: Int]
    
    var playerName: String {
        get {
            return _playerName
        }
    }
    var scores: [String: Int] {
        get {
            return _scores
        }
    }
    init(playerName: String, scores: [String: Int]) {
        _scores = scores
        _playerName = playerName
    }
    
    init(playerName: String, scores: [Int]) {
        _scores = ProfileCache.convertScoresArrayToDictionary(scores: scores)
        _playerName = playerName
    }
    
    private static func convertScoresArrayToDictionary(scores: [Int]) -> [String: Int] {
        var scoresDictionary: [String: Int] = [:]
        for i in 0..<scores.count {
            scoresDictionary[GAME_IDENTIFIERS_STRING_LITERALS[i]] = scores[i]
        }
        return scoresDictionary
    }
    
    func convertScoresDictionaryToArray() -> [Int] {
        var scores = [Int]()
        GAME_IDENTIFIERS_STRING_LITERALS.forEach { (gameMode) in
            scores.append(self.scores[gameMode]!)
        }
        return scores
    }
}
