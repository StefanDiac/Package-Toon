//
//  PowerUp Types.swift
//  Package Toon
//
//  Created by Air_Book on 4/17/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

enum PowerUpTypes {
    case doubleScore
    case extraLife
    case allPerfect
    case colorless
    
    static func getType(forValue number: Int) -> PowerUpTypes{
        switch(number) {
        case 0:
            return .doubleScore
        case 1:
            return .extraLife
        case 2:
            return .allPerfect
        case 3:
            return .colorless
        default:
            return .extraLife
        }
    }
    
    static func getTexture(forType type: PowerUpTypes) -> SKTexture {
        switch type {
        case .doubleScore:
            return SKTexture(imageNamed: "twoTimes")
        case .extraLife:
            return SKTexture(imageNamed: "extraHeartPowerUp")
        case .allPerfect:
            return SKTexture(imageNamed: "perfect_Power_Up")
        case .colorless:
            return SKTexture(imageNamed: "colorless")
        }
    }
    
    func getFunctionalityForType(gameScene: PackageDiscoScene) {
        switch self {
        case .doubleScore:
            gameScene.scoreLabel.changeDoubleScoreState()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 5.0, execute: {
                gameScene.scoreLabel.changeDoubleScoreState()
            })
            break;
        case .extraLife:
            if gameScene.canAddExtraLife() {
                gameScene.giveALifeBack()
            }
            break;
        case .colorless:
            gameScene.changeToColorless()
            break;
        case .allPerfect:
            gameScene.changeToAllPerfect()
            break;
        }
    }
}
