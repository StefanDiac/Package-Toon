//
//  ComboCharacterMediator.swift
//  Package Toon
//
//  Created by Air_Book on 6/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ComboCharacterMediator {
    let comboLabel: ComboLabel
    let character: CharacterNode
    let requiredHitsForDazzle: Int
    
    init(character: CharacterNode, comboLabel: ComboLabel, requiredHitsForDazzle: Int) {
        self.character = character
        self.comboLabel = comboLabel
        self.requiredHitsForDazzle = requiredHitsForDazzle
    }
    
    func checkForDazzle() {
        if comboLabel.updateValue % requiredHitsForDazzle == 0 && comboLabel.updateValue != 0{
            character.dazzleStateChange(wasFail: false)
        }
    }
    
    func comboWasDropped() {
        character.dazzleStateChange(wasFail: true)
    }
}
