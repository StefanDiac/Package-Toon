//
//  MenuScene.swift
//  /Users/air_book/Desktop/Swift/Package Toon/Package Toon.xcodeprojPackage Toon
//
//  Created by Air_Book on 2/27/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene, UITextFieldDelegate {
    
    var background: SKSpriteNode!
    var selectedBtnReference: MenuButton!
    let actionDelegator = ActionDelegator()
    var displayedFragment: MenuFragment?
    
    override func didMove(to view: SKView) {        
        addBackground()
        addMenuButtons()
        addGameTitleLogo()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            if displayedFragment == nil {
                let tappedNodes = nodes(at: location).filter {$0.name == "menuButton"}
                handleButtonPressOnScene(tappedNodes: tappedNodes)
            } else {
                delegateButtonPressHandlingToFragment(at: location)
            }
        }
    }
    
    func handleButtonPressOnScene(tappedNodes: [SKNode]) {
        if let menuButton = retriveMenuButtonReference(tappedNodes: tappedNodes) {
            if let actionType = menuButton.getActionType() {
                actionDelegator.delegateAction(type: actionType, currentScene: self)
            }
        }
    }
    
    func delegateButtonPressHandlingToFragment(at location: CGPoint) {
        let tappedFragment = nodes(at: location).compactMap{$0 as? MenuFragment}
        if let fragment = tappedFragment.first {
            displayedFragment = fragment
            let convertedLocation = convert(location, to: displayedFragment as! SKNode)
            displayedFragment!.handleButtonPress(callerScene: self, at: convertedLocation)
        }
    }
    
    func retriveMenuButtonReference(tappedNodes nodes: [SKNode]) -> MenuButton? {
        if nodes.count > 0 {
            let firstNode = nodes[0]
            let menuButton = firstNode as! MenuButton
            return menuButton
        }
        return nil
    }
    
    func createAMenuButton(at point: CGPoint, type actionType: ButtonActions) {
        let menuBtn = MenuButton(position: point, actionType: actionType)
        menuBtn.zPosition = 1
        menuBtn.addToScene(sceneToAddTo: self)
    }
    
    func addMenuButtons() {
        createAMenuButton(at: CGPoint(x: 350.5, y: 265), type: .selectGameMode)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.createAMenuButton(at: CGPoint(x: 982, y: 265), type: .highScore)
        })
       /* DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.createAMenuButton(at: CGPoint(x: 350.5, y: 137), type: .store)
        })*/
        //was 0.6 with the store button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4, execute: {
            self.createAMenuButton(at: CGPoint(x: 982, y: 137), type: .settings)
        })
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.createAMenuButton(at: CGPoint(x: 1270, y: 700), type: .social)
        }
    }
    
    func prepareForGameSelectionTransition() -> SKSpriteNode {
        let gameSelectionBackground = SKSpriteNode(imageNamed: "gameSelectionBackground")
        gameSelectionBackground.name = "background"
        gameSelectionBackground.zPosition = -1
        gameSelectionBackground.position = CGPoint(x: 665 + self.size.width, y: 375)
        addChild(gameSelectionBackground)
        return gameSelectionBackground
    }
    
    func prepareForHighScoreTransition() -> SKSpriteNode {
        let highScoreBackground = SKSpriteNode(imageNamed: "highscoreBackground")
        highScoreBackground.name = "background"
        highScoreBackground.zPosition = -1
        highScoreBackground.position = CGPoint(x: 667, y: 373 + self.size.height)
        addChild(highScoreBackground)
        return highScoreBackground
    }
    
    func runGameSelectionTransitionAnimation(gameSelectionBackground: SKSpriteNode) {
        let moveBackground = SKAction.moveTo(x: background.position.x - self.size.width, duration: 1.5)
        let moveGameSelectionBackground = SKAction.moveTo(x: gameSelectionBackground.position.x - self.size.width, duration: 1.5)
        background.run(moveBackground)
        gameSelectionBackground.run(moveGameSelectionBackground)
    }
    
    func runHighscoreTransitionAnimation(highScoreBackground: SKSpriteNode) {
        let moveBackground = SKAction.moveTo(y: background.position.y - self.size.height, duration: 1.5)
        let moveHighScoreBackground = SKAction.moveTo(y: highScoreBackground.position.y - self.size.height, duration: 1.5)
        background.run(moveBackground)
        highScoreBackground.run(moveHighScoreBackground)
    }
    
    func removeNonBackgroundNodes() {
        children.forEach({
            if $0.name != "background" {
                $0.removeFromParent()
            }
        })
    }
    
    func addBackground() {
        background = SKSpriteNode(imageNamed: "mainMenuBackgroundSolo")
        background.name = "background"
        background.zPosition = -1
        background.position = CGPoint(x: 667, y: 375)
        addChild(background)
    }
    
    func addGameTitleLogo() {
        let titleCard = SKSpriteNode(imageNamed: "titleLogo")
        titleCard.zPosition = 1
        titleCard.position = CGPoint(x: 667, y: 570)
        addChild(titleCard)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let fragmentWithTextField = displayedFragment as? FragmentWithTextField
        if let fragment = fragmentWithTextField {
            fragment.switchEditMode()
            callTextFieldFragmentOptions(fragment: fragment, text: textField.text)
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let editingFragment = displayedFragment as? FragmentWithTextField {
            editingFragment.switchEditMode()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func callTextFieldFragmentOptions(fragment: FragmentWithTextField, text: String?) {
        if let newString = text, text != "" {
            fragment.handleTextChangeWithValue(newValue: newString)
        } else {
            fragment.handleTextChangeWithEmptyInput()
        }
    }
    
    func switchFragment(newFragment: MenuFragment) {
        if let fragmentNode = displayedFragment as? SKNode {
            fragmentNode.removeFromParent()
            if let newFragmentNode = newFragment as? SKNode {
                displayedFragment = newFragment
                newFragmentNode.position = MenuScenePositionConstants.CENTER_OF_SCENE
                newFragmentNode.zPosition = 10
                addChild(newFragmentNode)
            }
        }
    }
}
