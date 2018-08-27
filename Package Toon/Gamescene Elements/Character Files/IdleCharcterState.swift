//
//  IdleCharcterState.swift
//  Package Toon
//
//  Created by Air_Book on 6/8/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class IdleCharacterState: CharacterState {
    let characterReference: CharacterNode
    
    init(characterReference: CharacterNode) {
        self.characterReference = characterReference
    }
    
    func provideStateAnimation() -> SKAction {
        let firstFrame = SKAction.setTexture(SKTexture(imageNamed: "idle_01"), resize: true)
        let waitFrame = SKAction.wait(forDuration: 0.2)
        let secondFrame = SKAction.setTexture(SKTexture(imageNamed: "idle_02"))
        let thridFrame = SKAction.setTexture(SKTexture(imageNamed: "idle_03"))
        let forthFrame = SKAction.setTexture(SKTexture(imageNamed: "idle_04"))
        let idleSequence = SKAction.sequence([firstFrame, waitFrame,secondFrame, waitFrame,thridFrame, waitFrame,forthFrame, waitFrame])
        let idleSequenceLoop = SKAction.repeatForever(idleSequence)
        return idleSequenceLoop
    }
    
    func handleStateChange() {
        DispatchQueue.main.async {
            self.characterReference.baseTexture.run(self.provideStateAnimation())
        }
    }
    
    
}
