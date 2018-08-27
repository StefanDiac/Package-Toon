//
//  PowerUpHolder.swift
//  Package Toon
//
//  Created by Air_Book on 4/21/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class PowerUpHolder {
    var locationsForPowerUps = [(CGPoint,Bool)]()
    var powerUpBubbles = [PowerUpBubble]()
    
    init() {
        let yLocation1 = 450
        let yLocation2 = 600
        let xLocation1 = 150
        let xLocation2 = 450
        let xLocation3 = 850
        let xLocation4 = 1150
        
        let location1 = CGPoint(x: xLocation1, y: yLocation1)
        let location2 = CGPoint(x: xLocation2, y: yLocation2)
        let location3 = CGPoint(x: xLocation3, y: yLocation2)
        let location4 = CGPoint(x: xLocation4, y: yLocation1)
        
        locationsForPowerUps.append(contentsOf: [(location1, true),(location2, true),(location3, true),(location4, true)])
    }
    
    func addRandomPowerUp() -> (PowerUpBubble, CGPoint)? {
        let spot = findNextEmptySpot()
        if let location = spot.0 {
            let randomPowerUp = PowerUpFactory.createRandomPowerUp()
            let bubble = PowerUpBubble(powerUp: randomPowerUp, indexInHolder: spot.1)
            return (bubble, location)
        }
        return nil
    }
    
    func findNextEmptySpot() -> (CGPoint?, Int) {
        var emptyLocation: CGPoint? = nil
        var index = -1
        for i in 0..<locationsForPowerUps.count {
            if emptyLocation == nil && locationsForPowerUps[i].1{
                    emptyLocation = locationsForPowerUps[i].0
                    index = i
                    locationsForPowerUps[i].1 = false
            }
        }
        return (emptyLocation, index)
    }

    
    func markSpotAsEmpty(index: Int) {
        locationsForPowerUps[index].1 = true
    }
}
