//
//  HeartNode.swift
//  Package Toon
//
//  Created by Air_Book on 4/1/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class HeartNode: SKSpriteNode, Animated {
    private var _heartState = HeartState.active
    private var heartsRestoreEmitter: SKEmitterNode?
    private let initialHeight: CGFloat
    private let initialWidth: CGFloat
    var heartState: HeartState {
        get {
            return _heartState
        }
    }
    
    init(imageNamed: String) {
        let texture = SKTexture(imageNamed: imageNamed)
        initialHeight = texture.size().height
        initialWidth = texture.size().width
        super.init(texture: texture, color: .clear, size: texture.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        switch heartState {
        case .active:
            DispatchQueue.main.async {
                self.createFirstAnimations { firstAnimationSet in
                    let returnToSizeHeight = SKAction.resize(toHeight: self.initialHeight, duration: 1)
                    let returnToSizeWidth = SKAction.resize(toWidth: self.initialWidth, duration: 1)
                    let changeSprite = SKAction.setTexture(SKTexture(imageNamed: "heartEmpty"))
            
                    let secondAnimationSet = SKAction.group([returnToSizeWidth, returnToSizeHeight, changeSprite])
                    let animationSequence = SKAction.sequence([firstAnimationSet, secondAnimationSet])
                    self.run(animationSequence)
                }
            }
            break;
        case .destroyed:
            if self.hasActions() {
                self.removeAllActions()
                self.size.height = initialHeight
                self.size.width = initialWidth
                self.zRotation = 0
            }
            let changeSprite = SKAction.setTexture(SKTexture(imageNamed: "heartFull"))
            self.run(changeSprite)
        }
    }
    
    private func createFirstAnimations(completion: (_ firstAnimationSet: SKAction) -> Void) {
        let enlargeHeightAnimation = SKAction.resize(toHeight: initialHeight + 20, duration: 0.4)
        let enlargeWidthAnimation = SKAction.resize(toWidth: initialWidth + 20, duration: 0.4)
        let shakeMotion = setupShakeMotion()
        let firstAnimationSet = SKAction.group([enlargeWidthAnimation, enlargeHeightAnimation, shakeMotion])
        completion(firstAnimationSet)
    }
    
    func changeHeartState() {
        switch self.heartState {
        case .active:
            self._heartState = .destroyed
            break;
        case .destroyed:
            self._heartState = .active
            break;
        }
    }
    
    private func setupShakeMotion() -> SKAction {
        let shakeLeftAnimation = SKAction.rotate(byAngle: 0.35, duration: 0.05)
        let shakeRightAnimation = SKAction.rotate(byAngle: -0.35, duration: 0.05)
        let shakeMotionSequence = SKAction.sequence([shakeLeftAnimation,shakeRightAnimation,shakeRightAnimation,shakeLeftAnimation])
        let shakeRepeatSequence = SKAction.repeat(shakeMotionSequence, count: 2)
        return shakeRepeatSequence
    }
}
