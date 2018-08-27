//
//  SocialFriendsFragment.swift
//  Package Toon
//
//  Created by Air_Book on 6/28/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit
import SpriteKit

class SocialFriendsFragment: FragmentBase, FragmentWithTextField, FragmentSwitches, UITableViewDelegate {
    var isEditing: Bool
    var addFriendButton: SKSpriteNode!
    var friendAddingField: UITextField!
    var friendsTableView: FriendsTableView!
    var friendFieldStatusLabel: SKLabelNode!
    var switchToProfileFragmentHitbox: SKSpriteNode!
    var ownCode: String!
    
    init(sceneToDisplayOn scene: SKScene) {
        isEditing = false
        super.init(scene: scene)
        changeFragmentBackground(imageNamed: "playerFriendsLoading")
        let hitBoxLocationAndSize = getLocationOfFragmentSwitcher(forBoxSize: CGSize(width: 187, height: 42), backgroundSize: background.size)
        switchToProfileFragmentHitbox = createFragmentSwitcherHitbox(toBeDisplayedAt: hitBoxLocationAndSize.0, boxSize: hitBoxLocationAndSize.1)
        addChild(switchToProfileFragmentHitbox)
        addChild(createCloseButton(isLoaded: false))
        FirebaseCacherMediator.loadFriendsInformation(forFriendFragment: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func handleLoadingComplete(withFriendCode code: String, withFriends friends: [(String, String)]) {
        changeFragmentBackground(imageNamed: "playerFriendsLoaded")
        addFriendCodeLabel(friendCode: code)
        addFriendAdditionButton()
        createFriendStatusLabel()
        closeButton.removeFromParent()
        closeButton = createCloseButton(isLoaded: true)
        closeButton.position.y = closeButton.position.y - 20
        addChild(closeButton)
        addFriendAdditionField()
        addFriendList(withFriends: friends)
    }
    
    func addFriendList(withFriends friends: [(String, String)]) {
        friendsTableView = FriendsTableView(frame: CGRect.zero, style: .plain, friendEntries: friends)
        friendsTableView.register(FriendTableCell.self, forCellReuseIdentifier: NSStringFromClass(FriendTableCell.self))
        callerScene.view?.addSubview(friendsTableView)
        addFriendListConstraints()
        friendsTableView.reloadData()
    }
    
    func addFriendListConstraints() {
        let positioningValues = getPositioningValuesForTable()
        friendsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: friendsTableView, attribute: .left, relatedBy: .equal, toItem: callerScene.view!, attribute: .leftMargin, multiplier: 1.0, constant: positioningValues.0).isActive = true
        NSLayoutConstraint(item: friendsTableView, attribute: .bottom, relatedBy: .equal, toItem: callerScene.view!, attribute: .bottomMargin, multiplier: 1.0, constant: positioningValues.1).isActive = true
        NSLayoutConstraint(item: friendsTableView, attribute: .right, relatedBy: .equal, toItem: callerScene.view!, attribute: .rightMargin, multiplier: 1.0, constant: positioningValues.2).isActive = true
        NSLayoutConstraint(item: friendsTableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: positioningValues.3).isActive = true
    }
    
    func getPositioningValuesForTable() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let screenType = UIScreen.main.sizeType
        switch screenType {
        case .unknown:
            return (0,0,0,0)
        case .iphone5_SE:
            return (-2,-58, 2,143)
        case .iphone6_6s_7_8:
            return (2,-65, 0,169)
        case .iphonePlus:
            return (3,-74, -3, 185)
        }
    }
    
    func addFriendCodeLabel(friendCode: String) {
        let friendCodeLabel = SKLabelNode(text: friendCode)
        friendCodeLabel.zPosition = 1
        friendCodeLabel.position = CGPoint(x: -345, y: 174)
        friendCodeLabel.fontName = "AvenirNext-Heavy"
        friendCodeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        ownCode = friendCode
        addChild(friendCodeLabel)
    }
    
    func addFriendAdditionButton() {
        addFriendButton = SKSpriteNode(imageNamed: "addButton")
        addFriendButton.zPosition = 1
        addFriendButton.position = CGPoint(x: 605, y: 187)
        addChild(addFriendButton)
    }
    
    func createFriendStatusLabel() {
        friendFieldStatusLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        friendFieldStatusLabel.zPosition = 1
        friendFieldStatusLabel.fontColor = UIColor.white
        friendFieldStatusLabel.fontSize = 25
        friendFieldStatusLabel.position = CGPoint(x: 330, y: 135)
        addChild(friendFieldStatusLabel)
    }
    
    func addFriendAdditionField() {
        friendAddingField = UITextField(frame: CGRect.zero)
        friendAddingField.backgroundColor = .clear
        friendAddingField.placeholder = "Enter Friend Code ( 8 characters*)"
        friendAddingField.textColor = UIColor.white
        friendAddingField.autocapitalizationType = UITextAutocapitalizationType.allCharacters
        friendAddingField.autocorrectionType = UITextAutocorrectionType.no
        friendAddingField.adjustsFontForContentSizeCategory = true
        friendAddingField.borderStyle = .none
        friendAddingField.returnKeyType = .done
        friendAddingField.clearButtonMode = .whileEditing
        friendAddingField.textAlignment = .center
        friendAddingField.font = UIFont(name: "AvenirNext-Heavy", size: 14)
        friendAddingField.keyboardType = .default
        friendAddingField.delegate = callerScene as? UITextFieldDelegate
        callerScene.view?.addSubview(friendAddingField)
        addFriendAdditionConstraints()
    }
    
    func addFriendAdditionConstraints() {
        let positioningValues = getPositioningValuesForFriendField()
        friendAddingField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: friendAddingField, attribute: .right, relatedBy: .equal, toItem: callerScene.view!, attribute: .rightMargin, multiplier: 1.0, constant: positioningValues.0).isActive = true
        NSLayoutConstraint(item: friendAddingField, attribute: .top, relatedBy: .equal, toItem: callerScene.view!, attribute: .topMargin, multiplier: 1.0, constant: positioningValues.1).isActive = true
        NSLayoutConstraint(item: friendAddingField, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: positioningValues.2).isActive = true
        NSLayoutConstraint(item: friendAddingField, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: positioningValues.3).isActive = true
    }
    
    func getPositioningValuesForFriendField() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let phoneType = UIScreen.main.sizeType
        switch phoneType {
        case .unknown :
            return (0,0,0,0)
        case .iphone5_SE:
            friendAddingField.font = UIFont(name: "AvenirNext-Heavy", size: 10)
            return (-21, 72, 207, 17)
        case .iphonePlus:
            return (-32, 94, 271, 21)
        case .iphone6_6s_7_8:
            return (-27, 85, 245, 18)
        }
    }
    
    func getLocationOfFragmentSwitcher(forBoxSize boxSize: CGSize, backgroundSize: CGSize) -> (CGPoint, CGSize) {
        let upperHeightOfBG = background.size.height/2
        let centerY = upperHeightOfBG - boxSize.height/2 - 19
        let leftWidthOfBG = background.size.width/2
        let centerX = -leftWidthOfBG + boxSize.width/2 + 20
        let locationOfHitbox = CGPoint(x: centerX, y: centerY)
        return (locationOfHitbox, boxSize)
    }
    
    override func handleButtonPress(callerScene: MenuScene, at location: CGPoint) {
        let nodesAtLocation = nodes(at: location)
        
        if nodesAtLocation.contains(closeButton) {
            removeTableViewFromFragment()
            callerScene.actionDelegator.delegateAction(type: .close, currentScene: callerScene)
        } else if let _ = addFriendButton, nodesAtLocation.contains(addFriendButton) {
            if isEditing {
                let _ = callerScene.textFieldShouldReturn(friendAddingField)
            } else {
                friendAddingField.becomeFirstResponder()
            }
        } else if nodesAtLocation.contains(switchToProfileFragmentHitbox) {
            removeTextFieldFromFragment()
            removeTableViewFromFragment()
            callerScene.switchFragment(newFragment: SocialProfileFragment(sceneToDisplayOn: callerScene))
        }
    }
    
    func handleLoadingError() {
        changeFragmentBackground(imageNamed: "playerFriendsError")
    }
    
    func handleTextChangeWithValue(newValue: String) {
        let friendCode = newValue.uppercased()
        if friendCode.count != 8 {
            handleFriendCodeLengthError()
        } else {
            if checkForCodeDifferentThanOwnCode(friendCode: friendCode, ownCode: ownCode) {
                resetFriendCodeStatusLabel()
                friendFieldStatusLabel.text = "Searching For Friend..."
                FirebaseDAO.attemptToAddFriend(friendCode: friendCode, withUpdatingFragment: self)
            }
        }
    }
    
    func addFriendToTable(friendCodeAndName: (String, String)) {
        if let _ = friendsTableView {
            friendsTableView.friendEntries.append(friendCodeAndName)
            friendsTableView.reloadData()
        }
    }
    
    func handleTextChangeWithEmptyInput() {
        handleFriendCodeLengthError()
    }
    
    func handleFriendCodeLengthError() {
        friendFieldStatusLabel.text = "Friend code must be of 8 characters"
        friendFieldStatusLabel.fontColor = UIColor.red
    }
    
    func handleFriendCodeNotFound() {
        friendFieldStatusLabel.text = "Friend code doesn't exist"
        friendFieldStatusLabel.fontColor = UIColor.red
    }
    
    func handleFriendCollisionFound() {
        friendFieldStatusLabel.text = "User is already your friend !"
        friendFieldStatusLabel.fontColor = UIColor.red
    }
    
    func resetFriendCodeStatusLabel() {
        friendFieldStatusLabel.text = ""
        friendFieldStatusLabel.fontColor = UIColor.white
    }
    
    func switchEditMode() {
        isEditing = !isEditing
    }
    
    func removeTableViewFromFragment() {
        if let _ = friendsTableView {
            friendsTableView.removeFromSuperview()
        }
    }
    
    func removeTextFieldFromFragment() {
        if let _ = friendAddingField {
            friendAddingField.removeFromSuperview()
        }
    }
    
    func handleLabelUpdateForNoConnection() {
        friendFieldStatusLabel.text = "Unable to connect to database"
        friendFieldStatusLabel.color = UIColor.red
    }
    
    func handleLabelUpdateForSuccess() {
        friendFieldStatusLabel.text = "Friend Added !"
        friendFieldStatusLabel.color = UIColor.white
    }
    
    func checkForCodeDifferentThanOwnCode(friendCode: String, ownCode: String) -> Bool {
        if friendCode == ownCode {
            friendFieldStatusLabel.text = "You're already your own friend !"
            friendFieldStatusLabel.color = UIColor.red
            return false
        }
        return true
    }
}
