//
//  ComboDazzleOKState.swift
//  Package Toon
//
//  Created by Air_Book on 6/8/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ComboDazzleCharacterState: CharacterState {
    let characterReference: CharacterNode
    let selectedDazzle: DazzleOption
    
    init(characterReference: CharacterNode, selectedOption: Int) {
        self.characterReference = characterReference
        self.selectedDazzle = characterReference.characterDazzles[selectedOption]
    }
    
    func provideStateAnimation() -> SKAction {
        var framesOfAnimation = [SKAction]()
        for i in 1...4 {
            framesOfAnimation.append(SKAction.setTexture(SKTexture(imageNamed: "\(selectedDazzle.provideImageNameForDazzle())_0\(i)"), resize: true))
            framesOfAnimation.append(SKAction.wait(forDuration: 0.05))
        }
        let dazzleOkSequence = SKAction.sequence(framesOfAnimation)
        return dazzleOkSequence
    }
    
    
    func handleStateChange() {
        characterReference.baseTexture.removeAllActions()
        characterReference.baseTexture.run(provideStateAnimation()) {
            self.characterReference.restoreIdleState()
        }
    }
}
