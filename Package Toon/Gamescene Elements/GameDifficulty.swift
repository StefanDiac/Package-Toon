//
//  GameDifficulty.swift
//  Package Toon
//
//  Created by Air_Book on 4/19/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

class GameDifficulty {
    private var xSpeed: Double
    private var timeInterval: Double
    private static let DEFAULT_X_SPEED  = 175.0
    private static let DEFAULT_TIME_INTERVAL = 1.5
    private var isLeftSide = true
    
    init() {
        xSpeed = GameDifficulty.DEFAULT_X_SPEED
        timeInterval = GameDifficulty.DEFAULT_TIME_INTERVAL
    }
    
    func increaseDifficulty() {
        xSpeed = xSpeed * 1.1
        timeInterval = timeInterval * 0.85
    }
    
    func resetDifficulty() {
        xSpeed = GameDifficulty.DEFAULT_X_SPEED
        timeInterval = GameDifficulty.DEFAULT_TIME_INTERVAL
    }
    
    func switchSide() {
        isLeftSide = !isLeftSide
    }
    
    func getSpeed() -> Double {
        if isLeftSide {
            return xSpeed
        } else {
            return -xSpeed
        }
    }
    
    func getTimeInterval() -> Double {
        return timeInterval
    }
}
