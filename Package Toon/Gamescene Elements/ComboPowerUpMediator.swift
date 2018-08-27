//
//  ComboPowerUpMediator.swift
//  Package Toon
//
//  Created by Air_Book on 4/19/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ComboPowerUpMediator {
    private var requiredHitsForGeneration: Int
    private var powerUpHolderReference: PowerUpHolder
    private var comboLabelReference: ComboLabel
    
    init(requiredHitsForGeneration: Int, powerUpHolder: PowerUpHolder, comboLabel: ComboLabel) {
        self.requiredHitsForGeneration = requiredHitsForGeneration
        self.powerUpHolderReference = powerUpHolder
        self.comboLabelReference = comboLabel
    }
    
    func checkIfCanGivePowerUp() -> Bool {
        if comboLabelReference.updateValue % requiredHitsForGeneration == 0 && comboLabelReference.updateValue != 0{
            return true
        }
        return false
    }
    
    func generateAPowerUp() -> (PowerUpBubble, CGPoint)? {
        return powerUpHolderReference.addRandomPowerUp()
    }
}
