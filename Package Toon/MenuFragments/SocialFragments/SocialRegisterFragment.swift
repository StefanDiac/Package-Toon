//
//  SocialFragment.swift
//  Package Toon
//
//  Created by Air_Book on 6/21/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class SocialRegisterFragment: FragmentBase {
    var errorLabel: SKLabelNode
    
    init(sceneToDisplayOn scene: SKScene) {
        errorLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        super.init(scene: scene)
        addChild(FacebookLoginManager.generateLogInButton(at: CGPoint(x: 0, y: 0)))
        addChild(MenuButton(position: CGPoint(x: 0, y: -280), actionType: .close))
        changeFragmentBackground(imageNamed: "blankFragmentBackground")
        configureErrorLabel()
    }
    
    override func handleButtonPress(callerScene: MenuScene, at point: CGPoint) {
        let nodesAtLocation = nodes(at: point)
        let buttonNode = nodesAtLocation.compactMap({$0 as? ConnectionButton}).first
        if let button = buttonNode {
            if button.type == .facebook {
                let facebookButton = button as! FacebookLoginButton
                facebookButton.handleAuthentification(fromRegisterFragment: self)
            }
        } else {
            let backbutton = nodesAtLocation.compactMap({$0 as? MenuButton}).filter({$0.getActionType() == .close}).first
            if let _ = backbutton {
                callerScene.actionDelegator.delegateAction(type: .close, currentScene: callerScene)
            }
        }
    }
    
    func configureErrorLabel() {
        errorLabel.text = ""
        errorLabel.fontSize = 34
        errorLabel.fontColor = .red
        errorLabel.position = CGPoint(x: 667, y: 650)
        errorLabel.zPosition = 3
        addChild(errorLabel)
    }
    
    func changeErrorLabel(withErrorText text: String) {
        errorLabel.text = text
    }
    
    func handleLoginFinished() {
        if let menuScene = callerScene as? MenuScene {
            menuScene.switchFragment(newFragment: SocialProfileFragment(sceneToDisplayOn: menuScene))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
