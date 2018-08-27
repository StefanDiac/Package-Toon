//
//  ActionsToDelegate.swift
//  Package Toon
//
//  Created by Air_Book on 3/2/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation
import SpriteKit

protocol StartGameAction {
    func startDiscoGame(currentScene: SKScene)
    func startNormalRushGame(currentScene: SKScene)
    func startFiveRushGame(currentScene: SKScene)
}

extension StartGameAction {
    func startDiscoGame(currentScene: SKScene) {
        let gameScene = PackageDiscoScene(size: currentScene.size)
        gameScene.scaleMode = .aspectFill
        currentScene.view?.presentScene(gameScene)
    }
    
    func startNormalRushGame(currentScene: SKScene) {
        let gameScene = RushDiscoScene(size: currentScene.size, startTime: 60, rewardTimeValue: 5, comboRequired: 25)
        gameScene.scaleMode = .aspectFill
        currentScene.view?.presentScene(gameScene)
    }
    
    func startFiveRushGame(currentScene: SKScene) {
        let gameScene = RushDiscoScene(size: currentScene.size, startTime: 5, rewardTimeValue: 1, comboRequired: 7)
        gameScene.scaleMode = .aspectFill
        currentScene.view?.presentScene(gameScene)
    }
}

protocol AboutAction {
    func about()
}

extension AboutAction {
    func about() {
        print("Displaying some information")
    }
}

protocol HighScoreAction {
    func highScore(currentScene: SKScene)
}

extension HighScoreAction {
    func highScore(currentScene: SKScene) {
        let highScoreScene = HighScoreScene(size: currentScene.size)
        highScoreScene.scaleMode = .aspectFit
        currentScene.view?.presentScene(highScoreScene)
    }
}

protocol RetryGameAction {
    func retry(currentScene: SKScene)
}

extension RetryGameAction {
    func retry(currentScene: SKScene) {
        if let _ = currentScene as? PackageDiscoScene {
            let newDiscoScene = PackageDiscoScene(size: currentScene.size)
            newDiscoScene.scaleMode = .aspectFill
            currentScene.view?.presentScene(newDiscoScene)
        }
        if let rushScene = currentScene as? RushDiscoScene {
            let newRushScene = RushDiscoScene(size: rushScene.size, startTime: rushScene.startTime, rewardTimeValue: rushScene.rewardTimeValue, comboRequired: rushScene.comboRequired)
            newRushScene.scaleMode = .aspectFill
            rushScene.view?.presentScene(newRushScene)
        }
    }
}

protocol BackToMenuAction {
    func back(currentScene: SKScene)
}

extension BackToMenuAction {
    func back(currentScene: SKScene) {
        let menuScene = MenuScene(size: currentScene.size)
        menuScene.scaleMode = .aspectFill
        
        if let highscoreScreen = currentScene as? HighScoreScene {
            highscoreScreen.scoreTable.removeFromSuperview()
        }
        
        currentScene.view?.presentScene(menuScene)
    }
}

protocol SelectGameModeAction {
    func selectGameMode(currentScene: SKScene)
}

extension SelectGameModeAction {
    func selectGameMode(currentScene: SKScene) {
        let gameSelectionScene = GameSelectionScene(size: currentScene.size)
        gameSelectionScene.scaleMode = .aspectFill
        
        currentScene.view?.presentScene(gameSelectionScene)
    }
}

protocol SocialFragmentDisplayAction {
        func displaySocialFragment(currentScene: SKScene)
    
}

extension SocialFragmentDisplayAction {
    func displaySocialFragment(currentScene: SKScene) {
        var socialFragment: FragmentBase
        if UserDefaultsSettingsManager.checkForLoginDetailsExistance() {
            socialFragment = SocialProfileFragment(sceneToDisplayOn: currentScene)
        } else {
            socialFragment = SocialRegisterFragment(sceneToDisplayOn: currentScene)
        }
        socialFragment.zPosition = 10
        socialFragment.position = MenuScenePositionConstants.CENTER_OF_SCENE
        currentScene.addChild(socialFragment)
        if let menuScene = currentScene as? MenuScene {
            menuScene.displayedFragment = socialFragment
        }
    }
}

protocol CloseFragmentAction {
    func closeFragment(currentScene: SKScene)
}

extension CloseFragmentAction {
    func closeFragment(currentScene: SKScene) {
        if let menuScene = currentScene as? MenuScene {
            if let textFieldFragment = menuScene.displayedFragment! as? FragmentWithTextField {
                textFieldFragment.removeTextFieldFromFragment()
            }
            if let fragment = menuScene.displayedFragment! as? SKNode {
                fragment.removeFromParent()
                menuScene.displayedFragment = nil
            }
        }
    }
}

protocol SettingsAction {
    func openSettingsFragment(currentScene: SKScene)
}

extension SettingsAction {
    func openSettingsFragment(currentScene: SKScene) {
        let settingsFragment: FragmentBase = SettingsFragment(sceneToDisplayOn: currentScene)
        settingsFragment.zPosition = 10
        settingsFragment.position = MenuScenePositionConstants.CENTER_OF_SCENE
        currentScene.addChild(settingsFragment)
        if let menuScene = currentScene as? MenuScene {
            menuScene.displayedFragment = settingsFragment
        }
    }
}
