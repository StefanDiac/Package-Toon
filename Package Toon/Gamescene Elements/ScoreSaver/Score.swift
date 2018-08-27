//
//  Score.swift
//  Package Toon
//
//  Created by Air_Book on 6/4/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class Score {
    private let _scoreValue: Int
    private var _scorePosition: Int
    private let _scoreDate: Date
    private let _scoreGameMode: ScoreGameMode
    
    public var scorePosition: Int {
        get {
            return self._scorePosition
        }
        set {
            self._scorePosition = newValue
        }
    }
    public var scoreValue: Int {
        get {
            return self._scoreValue
        }
    }
    public var scoreDate: Date {
        get {
            return self._scoreDate
        }
    }
    
    public var scoreGameMode: ScoreGameMode {
        get {
            return self._scoreGameMode
        }
    }
    
    init(scoreValue:Int, scorePosition: Int, scoreDate: Date, scoreGameMode: ScoreGameMode) {
        self._scoreDate = scoreDate
        self._scoreValue = scoreValue
        self._scoreGameMode = scoreGameMode
        self._scorePosition = scorePosition
    }
    
    init(scoreValue: Int, scoreDate: Date, scoreGameMode: ScoreGameMode) {
        self._scoreDate = scoreDate
        self._scoreValue = scoreValue
        self._scoreGameMode = scoreGameMode
        self._scorePosition = 0
    }
    
    func scoreToDisplayString() -> String {
        return "\(scorePosition). \(scoreValue), in mode \(scoreGameMode), on \(scoreDate.description)"
    }
}
