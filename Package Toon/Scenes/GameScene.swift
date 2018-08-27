//
//  GameScene.swift
//  Package Toon
//
//  Created by Air_Book on 3/8/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var boxesInPlay = [PackageContainer]()
    var conveyorBelt: ConveyorBelt!
    var comboLabel: ComboLabel!
    var scoreLabel: ScoreLabel!
    var gameOverScreen: GameEndOverlay!
    var isGameOver: Bool = true
    var actionDelegator: ActionDelegator!
    var boxDestoryEmitter: SKEmitterNode!
    var character: CharacterNode!
    var comboCharacterMediator: ComboCharacterMediator!
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let tappedNodes = nodes(at: touchLocation)
            if !isGameOver {
                let gameButton = tappedNodes.compactMap({ $0 as? GameButtonContainer }).first
                if let buttonPressed = gameButton {
                    handleButtonPress(gameButton: buttonPressed)
                } 
            } else {
                let menuButton = tappedNodes.compactMap({ $0 as? MenuButton}).first
                if let buttonPressed = menuButton {
                    actionDelegator = ActionDelegator()
                    actionDelegator.delegateAction(type: buttonPressed.getActionType()!, currentScene: self)
                }
            }
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    func initiateGame() {
        addBackground()
        conveyorBelt = ConveyorBelt()
        conveyorBelt.configure(at: CGPoint(x: 667, y: 275), forScene: self)
        addChild(conveyorBelt)
        if let perfectZoneEmitter = conveyorBelt.perfectEmitter, conveyorBelt.checkIfUserWantsParticles() {
            perfectZoneEmitter.position = conveyorBelt.position
            addChild(perfectZoneEmitter)
        }
        addGameButtonsToScene()
        addLabelsToScene()
        addCharacterToScreen()
        comboCharacterMediator = ComboCharacterMediator(character: character, comboLabel: comboLabel, requiredHitsForDazzle: 10)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.5, execute: startGame)
    }
    
    func addBackground() {
        let background = SKSpriteNode(imageNamed: "gameZoneBackground")
        background.zPosition = -1
        background.position = CGPoint(x: 667, y: 375)
        addChild(background)
    }
    
    func addCharacterToScreen() {
        let characterTexture = SKTexture(imageNamed: "idle_01")
        character = CharacterNode(characterTexture: characterTexture)
        character.position = CGPoint(x: 667, y: 505)
        character.zPosition = 2
        addChild(character)
        character.characterWarpToScreen()
    }
    
    func addGameButtonsToScene() {
        startAnimation(gameButton: createButton(at: CGPoint(x: 240, y: -90), colorType: .red), delay: 1.5)
        startAnimation(gameButton: createButton(at: CGPoint(x: 450, y: -90), colorType: .blue), delay: 2)
        startAnimation(gameButton: createButton(at: CGPoint(x: 660, y: -90), colorType: .green), delay: 2.3)
        startAnimation(gameButton: createButton(at: CGPoint(x: 870, y: -90), colorType: .yellow), delay: 2.5)
        startAnimation(gameButton: createButton(at: CGPoint(x: 1080, y: -90), colorType: .purple), delay: 2.6)
    }
    
    func addLabelsToScene() {
        scoreLabel = ScoreLabel()
        addChild(scoreLabel)
        comboLabel = ComboLabel()
        addChild(comboLabel)
    }
    
    func handleButtonPress(gameButton: GameButtonContainer) {}
    
    func gameOver() {
        isGameOver = true
        let screenSize = self.size
        gameOverScreen = GameEndOverlay(size: screenSize, gameEndMessage: "Game Over", score: scoreLabel.updateValue)
        gameOverScreen.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        addChild(gameOverScreen)
        character.handleGameOverForCharacter()
        if(scoreLabel.updateValue>0) {
            let scoreSaver = ScoreSaver()
            let isHighScore = scoreSaver.decideScoreAllocation(scoreToCheckForAdding: Score(scoreValue: scoreLabel.updateValue, scoreDate: Date.init(timeIntervalSinceNow: 0), scoreGameMode: ScoreGameMode.getGameMode(forScreen: self)))
            handleHighScore(isHighScore: isHighScore)
        }
    }
    
    func handleHighScore(isHighScore: Bool) {
        if isHighScore {
            FirebaseDAO.storeNewHighScore(scoreValue: scoreLabel.updateValue, gameMode: ScoreGameMode.getGameMode(forScreen: self).getFirebaseLiteralForGameMode())
        }
    }
    
    func startGame() {
        isGameOver = false
    }
    
    func createButton(at position: CGPoint, colorType: ButtonColors) -> GameButtonContainer{
        let gameButton = GameButtonContainer(colorType: colorType)
        gameButton.configure(at: position)
        addChild(gameButton)
        return gameButton
    }
    
    func startAnimation(gameButton: GameButtonContainer, delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            gameButton.animate()
        }
    }
    
    func dropCombo() {
        comboLabel.update(action: .reset)
        scoreLabel.changeScore(action: .reset, areaBehaviour: nil)
        comboCharacterMediator.comboWasDropped()
    }
}
