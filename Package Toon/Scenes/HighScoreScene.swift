//
//  HighScoreScene.swift
//  Package Toon
//
//  Created by Air_Book on 6/19/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class HighScoreScene: MenuScene {
    var scoreTable: HighscoreTableView!
    var gamemodeChanger: GameModeHighscoreChanger!
    var locationChanger: LocationOfHighscoreChanger!
    override func didMove(to view: SKView) {
        addBackground()
        addMenuButtons()
        addScoreTableToScene()
        addGameModeChanger()
        addHighscoreLocationChanger()
    }
    
    override func addBackground() {
        background = SKSpriteNode(imageNamed: "highscoreBackground")
        background.zPosition = -1
        background.position = CGPoint(x: 667, y: 375)
        addChild(background)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let location = touch.location(in: self)
            
            let nodesAtLocation = nodes(at: location)
            
            if nodesAtLocation.contains(gamemodeChanger) {
                gamemodeChanger.handleButtonPressed(highscoreScene: self)
                scoreTable.currentScoreType = gamemodeChanger.scoreGameMode
                scoreTable.reloadData()
            } else if nodesAtLocation.contains(locationChanger) {
                locationChanger.handleButtonPressed()
                scoreTable.isLocal = locationChanger.isLocal
                scoreTable.reloadData()
            }
        }
    }
    
    override func addMenuButtons() {
        let backToMainMenuButton = MenuButton(position: CGPoint(x: 1000, y: 50), actionType: .back)
        addChild(backToMainMenuButton)
    }
    
    func addScoreTableToScene() {
       scoreTable = HighscoreTableView(frame: CGRect(x: 120, y: 82, width: 450, height: 150), style: .grouped)
        scoreTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view?.addSubview(scoreTable)
        scoreTable.reloadData()
        addScoreTableConstraints()
    }
    
    func addScoreTableConstraints() {
        let constants = getConstraintsConstantsForModel()
        scoreTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: scoreTable, attribute: .top, relatedBy: .equal, toItem: self.view!, attribute: .topMargin, multiplier: 1.0, constant: constants.0).isActive = true
        NSLayoutConstraint(item: scoreTable, attribute: .right, relatedBy: .equal, toItem: self.view!, attribute: .rightMargin, multiplier: 1.0, constant: constants.1).isActive = true
        NSLayoutConstraint(item: scoreTable, attribute: .bottom, relatedBy: .equal, toItem: self.view!, attribute: .bottomMargin, multiplier: 1.0, constant: constants.2).isActive = true
        NSLayoutConstraint(item: scoreTable, attribute: .left, relatedBy: .equal, toItem: self.view!, attribute: .leftMargin, multiplier: 1.0, constant: constants.3).isActive = true
    }
    
    func getConstraintsConstantsForModel() -> (CGFloat, CGFloat, CGFloat, CGFloat) {
        let sizeType = UIScreen.main.sizeType
        switch sizeType {
        case .unknown:
            return (0,0,0,0)
        case .iphone5_SE:
            return (70,-75,-125,85)
        case .iphone6_6s_7_8:
            return (70,-75,-140,90)
        case .iphonePlus:
            return (78,-75,-151,98)
        }
    }
    
    func addGameModeChanger() {
        gamemodeChanger = GameModeHighscoreChanger()
        gamemodeChanger.position = CGPoint(x: 143, y: 245)
        gamemodeChanger.zPosition = 2
        addChild(gamemodeChanger)
    }
    
    func addHighscoreLocationChanger() {
        locationChanger = LocationOfHighscoreChanger()
        locationChanger.position = CGPoint(x: 140, y: 75)
        locationChanger.zPosition = 2
        addChild(locationChanger)
    }
}
