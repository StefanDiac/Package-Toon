//
//  PackageStateEnum.swift
//  Package Toon
//
//  Created by Air_Book on 3/19/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

enum PackageState {
    case idle
    case falling
    case wrong
    case dead
    case correct
    
    func animationToPerform(size: CGSize) -> (SKAction, Double) {
        switch self {
        case .idle:
            let heightBigger = SKAction.resize(toHeight: size.height*1.05, duration: 1.5)
            let widthBigger = SKAction.resize(toWidth: size.width*1.05, duration: 1.5)
            let biggerGroup = SKAction.group([heightBigger, widthBigger])
            let returnToHeight = SKAction.resize(toHeight: size.height, duration: 1.5)
            let returnToWidth = SKAction.resize(toWidth: size.width, duration: 1.5)
            let returnGroup = SKAction.group([returnToHeight, returnToWidth])
            let idleAnimation = SKAction.sequence([biggerGroup,returnGroup])
            return (idleAnimation, 3.0)
        default:
            let actionSet = SKAction()
            return (actionSet,0.0)
        }
        
    }
}
