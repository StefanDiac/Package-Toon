//
//  GameTimer.swift
//  Package Toon
//
//  Created by Air_Book on 7/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameTimer: SKNode {
    var gameTimerLabel = SKShadowTextNode()
    var gameTimerValue: Int {
        didSet {
            if gameTimerValue > startTime {
                gameTimerValue = startTime
            } else {
                if gameTimerValue >= 10 {
                    gameTimerLabel.updateText(text: "\(gameTimerValue)")
                } else {
                    gameTimerLabel.updateText(text: "0\(gameTimerValue)")
                }
            }
        }
    }
    
    private var startTime: Int
    
    init(startTime time: Int) {
        startTime = time
        gameTimerLabel.create(textToDisplay: "\(time)", fontSize: 56)
        gameTimerValue = time
        gameTimerLabel.position = CGPoint(x: 0, y: 0)
        super.init()
        addChild(gameTimerLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startTimer() {
        let wait = SKAction.wait(forDuration: 1)
        let changeTextBlock = SKAction.run {
            if self.gameTimerValue > 0 {
                self.gameTimerValue = self.gameTimerValue - 1
            } else {
                self.gameTimerLabel.updateText(text: "00")
            }
        }
        let startTimerSequence = SKAction.sequence([wait, changeTextBlock])
        self.run(SKAction.repeatForever(startTimerSequence))
    }
}
