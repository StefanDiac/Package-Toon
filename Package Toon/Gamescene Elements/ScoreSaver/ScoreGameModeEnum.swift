//
//  ScoreGameModeEnum.swift
//  Package Toon
//
//  Created by Air_Book on 6/4/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

enum ScoreGameMode {
    case disco
    case fiveRush
    case rush
    
    func caseToString() -> String {
        switch(self) {
        case .disco:
            return "Disco"
        case .fiveRush:
            return "5Rush"
        case .rush:
            return "Rush"
        }
    }
    
    static func getCase(forString string: String) throws -> ScoreGameMode {
        switch string {
        case "Disco":
            return .disco
        case "5Rush":
            return .fiveRush
        case "Rush":
            return .rush
        default:
            throw InvalidScoreGameMode.InvalidStringReceived
        }
    }
    
    static func getGameMode(forScreen: SKScene) -> ScoreGameMode{
        if let _ = forScreen as? PackageDiscoScene {
            return .disco
        } else if let rushScene = forScreen as? RushDiscoScene {
            if rushScene.comboRequired == 10 {
                return .fiveRush
            } else {
                return .rush
            }
        }
        return .disco
    }
    
    func getFirebaseLiteralForGameMode() -> String {
        switch self {
        case .disco:
            return GAME_IDENTIFIERS_STRING_LITERALS[0]
        case .rush:
            return GAME_IDENTIFIERS_STRING_LITERALS[1]
        case .fiveRush:
            return GAME_IDENTIFIERS_STRING_LITERALS[2]
        }
    }
}
