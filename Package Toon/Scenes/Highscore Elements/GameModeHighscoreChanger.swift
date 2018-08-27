//
//  GameModeHighscoreChanger.swift
//  Package Toon
//
//  Created by Air_Book on 7/3/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameModeHighscoreChanger: SKSpriteNode {
    var scoreGameMode: ScoreGameMode
    
    init() {
        let texture = SKTexture(imageNamed: "packageDiscoHighscoreButton")
        let width = texture.size().width * 0.65
        let height = texture.size().height * 0.65
        scoreGameMode = .disco
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: width, height: height))
    }
    
    func handleButtonPressed(highscoreScene: HighScoreScene) {
        switchTextureOnPress()
    }
    
    func switchTextureOnPress() {
        switch scoreGameMode {
        case .disco:
            self.texture = SKTexture(imageNamed: "discoRushHighscoreButton")
            scoreGameMode = .rush
            break;
        case .rush:
            self.texture = SKTexture(imageNamed: "5RushHighscoreButton")
            scoreGameMode = .fiveRush
            break;
        case .fiveRush:
            self.texture = SKTexture(imageNamed: "packageDiscoHighscoreButton")
            scoreGameMode = .disco
            break;
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
