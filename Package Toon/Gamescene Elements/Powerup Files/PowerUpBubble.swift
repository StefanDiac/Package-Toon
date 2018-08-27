//
//  PowerUpBubble.swift
//  Package Toon
//
//  Created by Air_Book on 6/17/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class PowerUpBubble: SKNode{
    private let _powerUp: PowerUp
    private let _bubble: SKSpriteNode
    var powerUp:PowerUp {
        get {
            return _powerUp
        }
    }
    var bubble: SKSpriteNode {
        get {
            return _bubble
        }
    }
    let indexInHolder: Int
    var originalSizeBubble: CGSize
    let originalSizeSprite: CGSize
    var interactable: Bool = false
    
    init(powerUp: PowerUp, indexInHolder: Int) {
        self._powerUp = powerUp
        self.indexInHolder = indexInHolder
        _bubble = SKSpriteNode(imageNamed: "powerUpBubble")
        originalSizeBubble = _bubble.size
        originalSizeSprite = _powerUp.size
        super.init()
        _powerUp.zPosition = 2
        _bubble.zPosition = 1
        _bubble.size = minimizeTexture(original: originalSizeBubble)
        _powerUp.size = minimizeTexture(original: originalSizeSprite)
        addChild(_powerUp)
        addChild(_bubble)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addToSceneAnimation(to destination: CGPoint){
        addBubbleSizeCorrectionValues()
        let bubbleMaximizeAnimation = getMaximizationAnimation(for: _bubble, originalSize: originalSizeBubble)
        let powerUpMaximizeAnimation = getMaximizationAnimation(for: _powerUp, originalSize: originalSizeSprite)
        let moveAnimation = SKAction.move(to: destination, duration: 1)
        _bubble.run(bubbleMaximizeAnimation)
        _powerUp.run(powerUpMaximizeAnimation)
        self.run(moveAnimation) {
            self.interactable = true
        }
    }
    
    func getMaximizationAnimation(for sprite: SKSpriteNode, originalSize: CGSize) -> SKAction {
        let maximizeWidthAnimation = SKAction.resize(toWidth: originalSize.width, duration: 1)
        let maximizeHeightAnimation = SKAction.resize(toHeight: originalSize.height, duration: 1)
        let animationGroup = SKAction.group([maximizeWidthAnimation, maximizeHeightAnimation])
        return animationGroup
    }
    
    func isClickable() -> Bool{
        return interactable
    }
    
    func addBubbleSizeCorrectionValues() {
        originalSizeBubble.width = originalSizeBubble.width * 1.7
        originalSizeBubble.height = originalSizeBubble.height * 1.7
    }
    
    func minimizeTexture(original: CGSize) -> CGSize {
        let newWidth = original.width * 0.1
        let newHeight = original.height * 0.1
        return CGSize(width: newWidth, height: newHeight)
    }
}
