//
//  GameButton.swift
//  Package Toon
//
//  Created by Air_Book on 3/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameButton: SKNode {
    func configure(at point: CGPoint, buttonColor: ButtonColors) {
        self.zPosition = 2
        self.position = point
        
        let colorBlindOption = GameOptionsManager().retriveColorBlindOption()
        
        let boardSprite = SKSpriteNode(color: .brown, size: CGSize(width: 175, height: 175))
        boardSprite.zPosition = self.zPosition
        boardSprite.position = CGPoint(x: 0, y: 0)
        addChild(boardSprite)
        
        let buttonSprite = SKSpriteNode(color: .red, size: CGSize(width: 142, height: 142))
        
        switch(buttonColor) {
        case .red:
            buttonSprite.color = ColorBlindOption.redForColorBlindType(forType: colorBlindOption)
            break;
        case .blue:
            buttonSprite.color = ColorBlindOption.blueForColorBlindType(forType: colorBlindOption)
            break;
        case .green:
            buttonSprite.color = ColorBlindOption.greenForColorBlindType(forType: colorBlindOption)
            break;
        case .yellow:
            buttonSprite.color = ColorBlindOption.yellowForColorBlindType(forType: colorBlindOption)
            break;
        case .purple:
            buttonSprite.color = ColorBlindOption.purpleForColorBlindType(forType: colorBlindOption)
            break;
        default:
            buttonSprite.color = ColorConstants.RED_PASTEL
        }
        
        buttonSprite.zPosition = 3
        buttonSprite.position = CGPoint(x: 0, y: 0)
        addChild(buttonSprite)
    }
}
