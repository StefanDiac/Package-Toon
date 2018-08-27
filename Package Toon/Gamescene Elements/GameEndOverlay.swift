//
//  GameEndOverlay.swift
//  Package Toon
//
//  Created by Air_Book on 4/7/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameEndOverlay: SKNode {
    let greyOverlay: SKSpriteNode
    let gameEndText: SKShadowTextNode
    let playerScore: SKShadowTextNode
    let options: [MenuButton]
    init(size: CGSize, gameEndMessage message: String, score: Int) {
        greyOverlay = SKSpriteNode(color: UIColor(red: 0.57, green: 0.58, blue: 0.6,alpha: 0.5), size: size)
        greyOverlay.zPosition = 10
        greyOverlay.position = CGPoint(x: 0, y: 0)
        
        gameEndText = SKShadowTextNode()
        gameEndText.create(textToDisplay: message, fontSize: 48)
        gameEndText.zPosition = 11
        gameEndText.position = CGPoint(x: 0, y: size.height/2-200)
        
        playerScore = SKShadowTextNode()
        playerScore.create(textToDisplay: "Score: \(score)", fontSize: 36)
        playerScore.zPosition = 11
        playerScore.position = CGPoint(x:0, y: 0)
        
        let retry = MenuButton(position: CGPoint(x: -size.width/4, y: -size.height/2+200), actionType: .retry)
        retry.zPosition = 11
        let goBack = MenuButton(position: CGPoint(x: size.width/4, y: -size.height/2+200), actionType: .back)
        goBack.zPosition = 11
        
        options = [retry,goBack]
        
        super.init()
        addChild(greyOverlay)
        addChild(playerScore)
        addChild(gameEndText)
        addChild(retry)
        addChild(goBack)
        self.zPosition = 9
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented")
    }
}
