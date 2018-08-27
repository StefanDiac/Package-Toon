//
//  GameSelectionScene.swift
//  Package Toon
//
//  Created by Air_Book on 4/14/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameSelectionScene: MenuScene {
    
    override func didMove(to view: SKView) {
        let scenePresentationName = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        scenePresentationName.fontSize = 72
        scenePresentationName.position = CGPoint(x: 667, y: 650)
        scenePresentationName.zPosition = 2
        scenePresentationName.text = "Select A Gamemode To Play"
        addChild(scenePresentationName)
        
        addBackground()
        addMenuButtons()
    }
    
    override func addMenuButtons() {
        createAMenuButton(at: CGPoint(x:667,y:550), type: .startPackageDisco)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.createAMenuButton(at: CGPoint(x:667, y:400), type: .startPackageRush)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.createAMenuButton(at: CGPoint(x:667, y: 250), type: .start5SecondsRush)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.createAMenuButton(at: CGPoint(x:667, y: 100), type: .back)
        }
    }
    
    override func addBackground() {
        background = SKSpriteNode(imageNamed: "gameSelectionBackground")
        background.zPosition = -1
        background.name = "background"
        background.position = CGPoint(x: 667, y: 375)
        addChild(background)
    }
    
    func prepareForMainMenuTransition() -> SKSpriteNode {
        let mainMenuBackground = SKSpriteNode(imageNamed: "mainMenuBackgroundSolo")
        mainMenuBackground.name = "background"
        mainMenuBackground.zPosition = -1
        mainMenuBackground.position = CGPoint(x: 669 - self.size.width, y: 375)
        addChild(mainMenuBackground)
        return mainMenuBackground
    }
    
    func runMainMenuTransitionAnimation(mainMenuBackground: SKSpriteNode) {
        let mainMenuAnimation = SKAction.moveTo(x: mainMenuBackground.position.x + self.size.width, duration: 1.5)
        let backgroundAnimation = SKAction.moveTo(x: background.position.x + self.size.width, duration: 1.5)
        background.run(backgroundAnimation)
        mainMenuBackground.run(mainMenuAnimation)
    }
    
    func prepareForGameSceneTransition() -> SKSpriteNode {
        let gameSceneBackground = SKSpriteNode(imageNamed: "gameZoneBackground")
        gameSceneBackground.name = "background"
        gameSceneBackground.zPosition = -1
        gameSceneBackground.position = CGPoint(x: 667, y: 377 - self.size.height)
        addChild(gameSceneBackground)
        return gameSceneBackground
    }
    
    func runGameSceneTransitionAnimation(gameSceneBackground: SKSpriteNode) {
        let gameSceneAnimation = SKAction.moveTo(y: gameSceneBackground.position.y + self.size.height, duration: 1.5)
        let backgroundAnimation = SKAction.moveTo(y: background.position.y + self.size.height, duration: 1.5)
        background.run(backgroundAnimation)
        gameSceneBackground.run(gameSceneAnimation)
    }
}
