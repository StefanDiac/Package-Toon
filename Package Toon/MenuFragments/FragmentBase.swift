//
//  FragmentBase.swift
//  Package Toon
//
//  Created by Air_Book on 6/24/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class FragmentBase: SKNode, MenuFragment {
    
    
    let backgroundDimming: SKSpriteNode
    let callerScene: SKScene
    var background: SKSpriteNode
    var closeButton: MenuButton!
    
    init(scene: SKScene) {
        callerScene = scene
        backgroundDimming = SKSpriteNode(texture: nil, color: UIColor(red: 0.14, green: 0.14, blue: 0.14, alpha: 0.8), size: scene.size)
        background = SKSpriteNode(texture: nil)
        super.init()
        createBasicBackground()
        backgroundDimming.zPosition = -1
        addChild(backgroundDimming)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createBasicBackground() {
        background = SKSpriteNode(imageNamed: "blankFragmentBackground")
        background.zPosition = 0
        background.position = CGPoint(x: 0, y: 0)
        addChild(background)
    }
    
    func changeFragmentBackground(imageNamed image: String) {
        background.texture = SKTexture(imageNamed: image)
    }
    
    func createCloseButton(isLoaded: Bool) -> MenuButton{
        if(isLoaded) {
            closeButton = MenuButton(position: CGPoint(x: -250, y: -280), actionType: .close)
        } else {
            closeButton = MenuButton(position: CGPoint(x: 615, y: 285), actionType: .smallClose)
        }
        return closeButton
    }
    
    func handleButtonPress(callerScene: MenuScene, at location: CGPoint) {}
}
