//
//  FailCharacterState.swift
//  Package Toon
//
//  Created by Air_Book on 6/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class FailCharacterState: CharacterState {
    
    let characterReference: CharacterNode
    let onRepeat: Bool
    
    init(characterReference: CharacterNode, onRepeat: Bool) {
        self.characterReference = characterReference
        self.onRepeat = onRepeat
    }
    
    func provideStateAnimation() -> SKAction {
        var animationsArray = [SKAction]()
        for i in 1...4 {
            animationsArray.append(SKAction.setTexture(SKTexture(imageNamed: "fail_0\(i)"), resize: true))
            if(onRepeat) {
                animationsArray.append(SKAction.wait(forDuration: 0.1))
            }
        }
        let animationSequence = SKAction.sequence(animationsArray)
        return animationSequence
    }
    
    func handleStateChange() {
        let animationsToRun = provideStateAnimation()
        characterReference.baseTexture.removeAllActions()
        if(onRepeat) {
            let animationOnRepeat = SKAction.repeatForever(animationsToRun)
            characterReference.baseTexture.run(animationOnRepeat)
        } else {
            characterReference.baseTexture.run(animationsToRun) {
                self.characterReference.restoreIdleState()
            }
        }
    }
}
