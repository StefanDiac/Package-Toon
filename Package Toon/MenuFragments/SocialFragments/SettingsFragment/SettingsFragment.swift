//
//  SettingsFragment.swift
//  Package Toon
//
//  Created by Air_Book on 7/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class SettingsFragment: FragmentBase {
    var gameOptions: GameOptionsManager
    var colorBlindOptionsPicker: ColorBlindOptionPicker!
    var enableGreenZonePartiblesButton: SKSpriteNode!
    var enableZoneInRushButton: SKSpriteNode!
    
    init(sceneToDisplayOn scene: SKScene) {
        self.gameOptions = GameOptionsManager()
        gameOptions.retriveAllOptions()
        super.init(scene: scene)
        addChild(createCloseButton(isLoaded: false))
        addColorBlindPicker()
        closeButton.position.x = closeButton.position.x - 20
        closeButton.position.y = closeButton.position.y + 22
        addDescriptionLabels()
        addEffectsSelector()
        addRushZoneSelector()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addEffectsSelector() {
        if gameOptions.greenZoneOption {
            enableGreenZonePartiblesButton = SKSpriteNode(imageNamed: "acceptButton")
        } else {
            enableGreenZonePartiblesButton = SKSpriteNode(imageNamed: "cancelButton")
        }
        enableGreenZonePartiblesButton.position = CGPoint(x: 235, y: 110)
        enableGreenZonePartiblesButton.zPosition = 3
        addChild(enableGreenZonePartiblesButton)
    }
    
    func addRushZoneSelector() {
        if gameOptions.rushZoneOption {
            enableZoneInRushButton = SKSpriteNode(imageNamed: "acceptButton")
        } else {
            enableZoneInRushButton = SKSpriteNode(imageNamed: "cancelButton")
        }
        enableZoneInRushButton.position = CGPoint(x: 235, y: 53)
        enableZoneInRushButton.zPosition = 3
        addChild(enableZoneInRushButton)
    }
    
    func addDescriptionLabels() {
        let colorBlindLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        colorBlindLabel.zPosition = 10
        colorBlindLabel.text = "Color Blind Mode"
        colorBlindLabel.fontSize = 34
        colorBlindLabel.position = CGPoint(x: 32, y: 300)
        colorBlindLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        colorBlindLabel.fontColor = UIColor.white
        addChild(colorBlindLabel)
        
        let greenZoneLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        greenZoneLabel.fontColor = .white
        greenZoneLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        greenZoneLabel.text = "Enable Green Zone Particles"
        greenZoneLabel.position = CGPoint(x: -80, y: 107)
        greenZoneLabel.zPosition = 3
        addChild(greenZoneLabel)
        
        let zoneInRushLabel = SKLabelNode(fontNamed: "AvenirNext-Heavy")
        zoneInRushLabel.fontColor = .white
        zoneInRushLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        zoneInRushLabel.text = "Enable Zone In Rush Modes"
        zoneInRushLabel.position = CGPoint(x: -80, y: 50)
        zoneInRushLabel.zPosition = 3
        addChild(zoneInRushLabel)
    }
    
    func addColorBlindPicker() {
        colorBlindOptionsPicker = ColorBlindOptionPicker(frame: CGRect.zero, fragmentToDisplayOn: self)
        colorBlindOptionsPicker.selectRow(colorBlindOptionsPicker.getRowForComponent(option: gameOptions.colorBlindOption), inComponent: 0, animated: true)
        colorBlindOptionsPicker.backgroundColor = UIColor(red: 0.106, green: 0.282, blue: 0.31, alpha: 1.0)
        colorBlindOptionsPicker.translatesAutoresizingMaskIntoConstraints = false
        callerScene.view?.addSubview(colorBlindOptionsPicker)
        addPickerConstratints()
    }
    
    func addPickerConstratints() {
        let centerConstraint = NSLayoutConstraint(item: colorBlindOptionsPicker, attribute: .centerX, relatedBy: .equal, toItem: callerScene.view!, attribute: .centerX, multiplier: 1.0, constant: 18.0)
        centerConstraint.priority = .required
        centerConstraint.isActive = true
        NSLayoutConstraint(item: colorBlindOptionsPicker, attribute: .top, relatedBy: .equal, toItem: callerScene.view!, attribute: .topMargin, multiplier: 1.0, constant: 55).isActive = true
        NSLayoutConstraint(item: colorBlindOptionsPicker, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 45).isActive = true
        NSLayoutConstraint(item: colorBlindOptionsPicker, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200).isActive = true
    }
    
    override func handleButtonPress(callerScene: MenuScene, at location: CGPoint) {
        let nodesAtLocation = nodes(at: location)
        if nodesAtLocation.contains(closeButton) {
            colorBlindOptionsPicker.removeFromSuperview()
            callerScene.actionDelegator.delegateAction(type: closeButton.getActionType()!, currentScene: callerScene)
        }
        if nodesAtLocation.contains(enableGreenZonePartiblesButton) {
            if gameOptions.greenZoneOption {
                gameOptions.greenZoneOption = false
                gameOptions.setGreenZoneParticles(isActive: false)
                enableGreenZonePartiblesButton.texture = SKTexture(imageNamed: "cancelButton")
            } else {
                gameOptions.greenZoneOption = true
                gameOptions.setGreenZoneParticles(isActive: true)
                enableGreenZonePartiblesButton.texture = SKTexture(imageNamed: "acceptButton")
            }
        }
        
        if nodesAtLocation.contains(enableZoneInRushButton) {
            if gameOptions.rushZoneOption {
                gameOptions.rushZoneOption = false
                gameOptions.setRushZoneParticles(isActive: false)
                enableZoneInRushButton.texture = SKTexture(imageNamed: "cancelButton")
            } else {
                gameOptions.rushZoneOption = true
                gameOptions.setRushZoneParticles(isActive: true)
                enableZoneInRushButton.texture = SKTexture(imageNamed: "acceptButton")
            }
        }
    }
}
