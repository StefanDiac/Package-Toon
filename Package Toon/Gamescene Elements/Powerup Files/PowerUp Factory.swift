//
//  PowerUp Factory.swift
//  Package Toon
//
//  Created by Air_Book on 4/17/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation
import GameplayKit

class PowerUpFactory {
    
    static func createRandomPowerUp() -> PowerUp {
        let randomValueType = GKRandomDistribution(lowestValue: 0, highestValue: 3)
        let powerUpType = PowerUpTypes.getType(forValue: randomValueType.nextInt())
        let powerUp = PowerUp(type: powerUpType)
        return powerUp
    }
}
