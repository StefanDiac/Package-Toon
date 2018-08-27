//
//  GameButtonContainer.swift
//  Package Toon
//
//  Created by Air_Book on 3/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameButtonContainer: SKNode, Animated, ColorType {
    let colorType: ButtonColors
    
    func animate() {
        let rotationAnimation = SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0.7)
        let moveUpAnimation = SKAction.moveBy(x: 0, y: 180, duration: 0.7)
        let animationPair = SKAction.group([rotationAnimation,moveUpAnimation])
        self.run(animationPair)
    }
    
    func configure(at point: CGPoint) {
        self.position = point
        self.zRotation = CGFloat(-Double.pi/2)
        
        let handleSprite = SKSpriteNode(color: .brown, size: CGSize(width: 25, height: 390))
        handleSprite.zPosition = 1
        handleSprite.position = CGPoint(x: 0, y: -handleSprite.size.height/2)
        addChild(handleSprite)
        
        let gameButton = GameButton()
        gameButton.configure(at: CGPoint(x:0,y:0), buttonColor: colorType)
        addChild(gameButton)
    }
    
    required init(colorType: ButtonColors) {
        self.colorType = colorType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
