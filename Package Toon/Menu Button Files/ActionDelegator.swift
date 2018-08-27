//
//  ActionDelegator.swift
//  Package Toon
//
//  Created by Air_Book on 3/2/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ActionDelegator: StartGameAction, AboutAction, HighScoreAction, RetryGameAction, BackToMenuAction, SelectGameModeAction, SocialFragmentDisplayAction, CloseFragmentAction, SettingsAction {
    
    func delegateAction(type actionType: ButtonActions, currentScene scene: SKScene) {
        var delay: Double = 0
        switch(actionType) {
        case .startPackageDisco:
            if let gameSelectionScene = scene as? GameSelectionScene {
                let gameSceneBG = gameSelectionScene.prepareForGameSceneTransition()
                gameSelectionScene.removeNonBackgroundNodes()
                gameSelectionScene.runGameSceneTransitionAnimation(gameSceneBackground: gameSceneBG)
                delay = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.startDiscoGame(currentScene: scene)
            }
            break;
        case .store:
            about()
            break;
        case .highScore:
            if let menuScene = scene as? MenuScene {
                let highScoreBG = menuScene.prepareForHighScoreTransition()
                menuScene.removeNonBackgroundNodes()
                menuScene.runHighscoreTransitionAnimation(highScoreBackground: highScoreBG)
                delay = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.highScore(currentScene: scene)
            }
            break;
        case .retry:
            retry(currentScene: scene)
            break;
        case .back:
            if let gameSelectionScene = scene as? GameSelectionScene {
                let mainMenuBG = gameSelectionScene.prepareForMainMenuTransition()
                gameSelectionScene.removeNonBackgroundNodes()
                gameSelectionScene.runMainMenuTransitionAnimation(mainMenuBackground: mainMenuBG)
                delay = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.back(currentScene: scene)
            }
            break;
        case .selectGameMode:
            if let menuScene = scene as? MenuScene {
                let gameSelectionBG = menuScene.prepareForGameSelectionTransition()
                menuScene.removeNonBackgroundNodes()
                menuScene.runGameSelectionTransitionAnimation(gameSelectionBackground: gameSelectionBG)
                delay = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.selectGameMode(currentScene: scene)
            }
            break;
        case .startPackageRush:
            if let gameSelectionScene = scene as? GameSelectionScene {
                let gameSceneBG = gameSelectionScene.prepareForGameSceneTransition()
                gameSelectionScene.removeNonBackgroundNodes()
                gameSelectionScene.runGameSceneTransitionAnimation(gameSceneBackground: gameSceneBG)
                delay = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.startNormalRushGame(currentScene: scene)
            }
            break;
        case .start5SecondsRush:
            if let gameSelectionScene = scene as? GameSelectionScene {
                let gameSceneBG = gameSelectionScene.prepareForGameSceneTransition()
                gameSelectionScene.removeNonBackgroundNodes()
                gameSelectionScene.runGameSceneTransitionAnimation(gameSceneBackground: gameSceneBG)
                delay = 1.5
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                self.startFiveRushGame(currentScene: scene)
            }
            break;
        case .settings:
            openSettingsFragment(currentScene: scene)
            break;
        case .social:
            displaySocialFragment(currentScene: scene)
            break;
        case .close, .smallClose:
            closeFragment(currentScene: scene)
            break;
        }
    }
}
