//
//  CharacterNode.swift
//  Package Toon
//
//  Created by Air_Book on 6/8/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit
import GameplayKit

class CharacterNode: SKNode {
    var baseTexture: SKSpriteNode
    var characterState: CharacterState!
    var characterDazzles: [DazzleOption]
    var isGameOver: Bool = false
    
    init(characterTexture: SKTexture) {
        self.baseTexture = SKSpriteNode(texture: characterTexture)
        baseTexture.zPosition = 1
        baseTexture.alpha = 0
        baseTexture.position = CGPoint(x: 0, y: 0)
        self.characterDazzles = [.ok, .dab, .surf]
        super.init()
        addChild(baseTexture)
        characterState = IdleCharacterState(characterReference: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func characterWarpToScreen() {
        let teleportationEmitter = SKEmitterNode(fileNamed: "TeleportationParticles")
        if let emitter = teleportationEmitter {
            emitter.zPosition = 5
            emitter.position.y = -baseTexture.size.height/2
            emitter.position.x = 10
            addChild(emitter)
            emitter.run(SKAction.fadeOut(withDuration: 1.5))
        }
        let fadeInAction = SKAction.fadeIn(withDuration: 2)
        baseTexture.run(fadeInAction) {
            self.characterState.handleStateChange()
            teleportationEmitter?.removeFromParent()
        }
    }
    
    func restoreIdleState() {
        characterState = IdleCharacterState(characterReference: self)
        characterState.handleStateChange()
    }
    
    func dazzleStateChange(wasFail: Bool) {
        if wasFail {
            characterState = FailCharacterState(characterReference: self, onRepeat: isGameOver)
            characterState.handleStateChange()
        } else {
            characterState = selectRandomDazzleState()
            characterState.handleStateChange()
        }
    }
    
    func handleGameOverForCharacter() {
        isGameOver = true
    }
    
    func selectRandomDazzleState() -> CharacterState {
        let randomValueGenerator = GKARC4RandomSource()
        let randomValue = randomValueGenerator.nextInt(upperBound: 3)
        return ComboDazzleCharacterState(characterReference: self, selectedOption: randomValue)
    }
}
