//
//  ButtonActionsEnum.swift
//  Package Toon
//
//  Created by Air_Book on 3/2/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

enum ButtonActions {
    case startPackageDisco
    case startPackageRush
    case start5SecondsRush
    case settings
    case store
    case highScore
    case retry
    case back
    case selectGameMode
    case social
    case close
    case smallClose
    
    static func getImageName(forCase: ButtonActions) -> String {
        switch forCase {
        case .startPackageRush:
            return "packageRushButton"
        case .startPackageDisco:
            return "packageDiscoButton"
        case .start5SecondsRush:
            return "5SecondRushButton"
        case .back:
            return "backToMenuButton"
        case .highScore:
            return "highScoreButton"
        case .settings:
            return "settingsGameButton"
        case .store:
            return "storeButton"
        case .retry:
            return "playAgainButton"
        case .selectGameMode:
            return "startGameButton"
        case .social:
            return "socialButton"
        case .close:
            return "closeFragmentButton"
        case .smallClose:
            return "cancelButton"
        }
    }
}
