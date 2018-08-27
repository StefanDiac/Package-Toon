//
//  SocialProfileFragment.swift
//  Package Toon
//
//  Created by Air_Book on 6/24/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit
import UIKit

class SocialProfileFragment: FragmentBase, FragmentWithTextField, FragmentSwitches {
    
    var isEditing: Bool
    var playerNameTextEdit: UITextField!
    var editButton: SKSpriteNode!
    var playerName: String!
    var switchToFriendsFragmentHitbox: SKSpriteNode!
    
    init(sceneToDisplayOn scene: SKScene) {
        isEditing = false
        super.init(scene: scene)
        changeFragmentBackground(imageNamed: "playerProfileLoading")
        let hitboxLocationAndSize = getLocationOfFragmentSwitcher(forBoxSize: CGSize(width: 187, height: 42), backgroundSize: background.size)
        switchToFriendsFragmentHitbox = createFragmentSwitcherHitbox(toBeDisplayedAt: hitboxLocationAndSize.0, boxSize: hitboxLocationAndSize.1)
        addChild(switchToFriendsFragmentHitbox)
        addChild(createCloseButton(isLoaded: false))
        FirebaseCacherMediator.loadProfileInformation(forProfileFragment: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func handleButtonPress(callerScene: MenuScene, at location: CGPoint) {
        let nodesAtLocation = nodes(at: location)
        
        if nodesAtLocation.contains(closeButton) {
            callerScene.actionDelegator.delegateAction(type: closeButton.getActionType()!, currentScene: callerScene)
        } else if let _ = editButton, nodesAtLocation.contains(editButton) {
            if isEditing {
                let _ = callerScene.textFieldShouldReturn(playerNameTextEdit)
            } else {
                playerNameTextEdit.becomeFirstResponder()
            }
        } else if nodesAtLocation.contains(switchToFriendsFragmentHitbox) {
            removeTextFieldFromFragment()
            callerScene.switchFragment(newFragment: SocialFriendsFragment(sceneToDisplayOn: callerScene))
        }
    }
    
    func changeFragmentForLoaded(scoreValues: [Int], playerName: String) {
        background.texture = SKTexture(imageNamed: "playerProfileLoaded")
        closeButton.removeFromParent()
        addCharacterSprite()
        addChild(createCloseButton(isLoaded: true))
        addScoreLabels(scoreValues: scoreValues)
        self.playerName = playerName
        addPlayerNameLabel(playerName: playerName)
        addEditButton()
    }
    
    func changeFragmentForError() {
        background.texture = SKTexture(imageNamed: "playerProfileError")
    }
    
    private func addScoreLabels(scoreValues: [Int]) {
        var heightDifference = -51
        scoreValues.forEach({
            let scoreLabelNode = SKLabelNode(text: "\($0)")
            scoreLabelNode.zPosition = 2
            scoreLabelNode.position = CGPoint(x: -40, y: heightDifference)
            heightDifference = heightDifference - 75
            scoreLabelNode.fontName = "AvenirNext-Heavy"
            scoreLabelNode.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
            self.addChild(scoreLabelNode)
        })
    }
    
    func getLocationOfFragmentSwitcher(forBoxSize boxSize: CGSize,backgroundSize: CGSize) -> (CGPoint, CGSize) {
        let upperHeightOfBG = background.size.height/2
        let centerY = upperHeightOfBG - boxSize.height/2 - 19
        let leftWidthOfBG = background.size.width/2
        let centerX = -leftWidthOfBG + boxSize.width + boxSize.width/2 + 20
        let locationOfHitbox = CGPoint(x: centerX, y: centerY)
        return (locationOfHitbox, boxSize)
    }
    
    private func addPlayerNameLabel(playerName: String) {
        playerNameTextEdit = UITextField(frame: CGRect.zero)
        playerNameTextEdit.keyboardType = UIKeyboardType.default
        playerNameTextEdit.font =  UIFont(name: "AvenirNext-Heavy", size: 20)
        playerNameTextEdit.textColor = UIColor.white
        playerNameTextEdit.textAlignment = .center
        playerNameTextEdit.borderStyle = .none
        playerNameTextEdit.placeholder = "Enter your new name"
        playerNameTextEdit.text = playerName
        playerNameTextEdit.autocorrectionType = UITextAutocorrectionType.default
        playerNameTextEdit.autocapitalizationType = UITextAutocapitalizationType.words
        playerNameTextEdit.clearButtonMode = UITextFieldViewMode.whileEditing
        playerNameTextEdit.backgroundColor = UIColor.clear
        playerNameTextEdit.delegate = callerScene as? UITextFieldDelegate
        playerNameTextEdit.returnKeyType = .done
        callerScene.view?.addSubview(playerNameTextEdit)
        addPlayerEditConstraints()
    }
    
    func addPlayerEditConstraints() {
        let positioningValues = getPositioningValuesBasedOnPhone()
        playerNameTextEdit.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: playerNameTextEdit, attribute: .right, relatedBy: .equal, toItem: callerScene.view!, attribute: .rightMargin, multiplier: 1.0, constant: positioningValues.0).isActive = true
        NSLayoutConstraint(item: playerNameTextEdit, attribute: .top, relatedBy: .equal, toItem: callerScene.view!, attribute: .topMargin, multiplier: 1.0, constant: positioningValues.1).isActive = true
        NSLayoutConstraint(item: playerNameTextEdit, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: positioningValues.2).isActive = true
        NSLayoutConstraint(item: playerNameTextEdit, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: positioningValues.3).isActive = true
    }
    
    func getPositioningValuesBasedOnPhone() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let phoneType = UIScreen.main.sizeType
        switch phoneType {
        case .unknown :
            return (0,0,0,0)
        case .iphone5_SE:
            playerNameTextEdit.font = UIFont(name: "AvenirNext-Heavy", size: 18)
            return (-23, 70, 340, 17)
        case .iphonePlus:
            return (-37, 91, 439, 25)
        case .iphone6_6s_7_8:
            return (-31, 83, 397, 20)
        }
    }
    
    private func addCharacterSprite() {
        let characterSprite = SKSpriteNode(imageNamed: "idle_01")
        characterSprite.zPosition = 2
        characterSprite.position = CGPoint(x: 385, y: -125)
        addChild(characterSprite)
    }
    
    private func addEditButton() {
        editButton = SKSpriteNode(imageNamed: "editTextButton")
        editButton.name = "edit"
        editButton.zPosition = 2
        editButton.position = CGPoint(x: 605, y: 192)
        addChild(editButton)
    }
    
    func handleTextChangeWithValue(newValue: String) {
        if FirebaseDAO.changeUserDisplayName(profileFragment: self, newDisplayName: newValue) {
            playerName = newValue
        } else {
            playerNameTextEdit.text = playerName
        }
    }
    
    func handleTextChangeWithEmptyInput() {
        playerNameTextEdit.text = playerName
    }
    
    func switchEditMode() {
        isEditing = !isEditing
    }
    
    func removeTextFieldFromFragment() {
        if let _ = playerNameTextEdit {
            playerNameTextEdit.removeFromSuperview()
        }
    }
    
    func restoreNameInCaseOfNoConnetion() {
        playerNameTextEdit.text = playerName
    }
}
