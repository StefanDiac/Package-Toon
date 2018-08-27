//
//  MenuButton.swift
//  Package Toon
//
//  Created by Air_Book on 2/27/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class MenuButton: SKNode{
    //TO DO - Rewrite to use an init rather than a config?
    private let background: SKSpriteNode!
    //Write an extension to SKLabelNode to include adding shadows
    private var actionType: ButtonActions!
    
    init(position: CGPoint, actionType: ButtonActions) {
        background = SKSpriteNode(imageNamed: ButtonActions.getImageName(forCase: actionType))
        background.zPosition = 1
        //Redo this messy code
        if(actionType != .social && actionType != .smallClose) {
            background.size = CGSize(width: background.size.width - 80, height: background.size.height - 10)
        }
        
        super.init()
        self.actionType = actionType
        self.position = position
        self.name = "menuButton"
        addChild(background)
    }
    
    func addToScene(sceneToAddTo: SKScene) {
        let currentSize = background.size
        background.size.width = background.size.width * 0.05
        background.size.height = background.size.height * 0.05
        sceneToAddTo.addChild(self)
        DispatchQueue.main.async {
            self.runPopAnimation(forOldSize: currentSize)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func runPopAnimation(forOldSize oldSize: CGSize) {
        let restoreWidth = SKAction.resize(toWidth: oldSize.width, duration: 0.5)
        let restoreHeight = SKAction.resize(toHeight: oldSize.height, duration: 0.5)
        let restoreAnimation = SKAction.group([restoreWidth,restoreHeight])
        background.run(restoreAnimation)
    }
    
    func getActionType() -> ButtonActions? {
        return self.actionType
    }
}
