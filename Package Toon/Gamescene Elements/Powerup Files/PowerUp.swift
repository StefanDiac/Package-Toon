//
//  PowerUpSprite.swift
//  Package Toon
//
//  Created by Air_Book on 4/21/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class PowerUp: SKSpriteNode {
    private let type: PowerUpTypes
    
    init(type: PowerUpTypes) {
        let texture = PowerUpTypes.getTexture(forType: type)
        self.type = type
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    func getType() -> PowerUpTypes {
        return type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
