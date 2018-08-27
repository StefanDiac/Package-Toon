//
//  LocationOfHighscoreChanger.swift
//  Package Toon
//
//  Created by Air_Book on 7/3/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class LocationOfHighscoreChanger: SKSpriteNode {
    var isLocal: Bool = true
    
    init() {
        let texture = SKTexture(imageNamed: "highscoreLocalButton")
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
    }
    
    func handleButtonPressed() {
        isLocal = !isLocal
        if isLocal {
            texture = SKTexture(imageNamed: "highscoreLocalButton")
        } else {
            texture = SKTexture(imageNamed: "highscoreOnlineButton")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
