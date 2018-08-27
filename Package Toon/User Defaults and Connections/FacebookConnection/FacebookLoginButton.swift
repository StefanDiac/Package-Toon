//
//  FacebookLoginButton.swift
//  Package Toon
//
//  Created by Air_Book on 6/22/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class FacebookLoginButton: SKSpriteNode, ConnectionButton {
    
    var type: AuthentificationType
    
    func handleAuthentification(fromRegisterFragment fragment: SocialRegisterFragment) {
        FacebookLoginManager.registerWithFacebook(viewController: GameViewController.controllerReference!, fromRegisterFragment: fragment)
    }
    
    init(type: AuthentificationType) {
        let texture = SKTexture(imageNamed: "facebookButton")
        self.type = type
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        zPosition = 2
        name = "facebookLogin"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
