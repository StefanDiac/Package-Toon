//
//  PackageDiscoScene.swift
//  Package Toon
//
//  Created by Air_Book on 4/16/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class PackageDiscoScene: GameScene {
    static let permittedDegreeOfError = 0.8
    var OUTSIDE_BOUNDS_DEGREE_ERROR: CGFloat {
        get {
            if conveyorBelt.fireZone.isRight {
                return CGFloat(20)
            } else {
                return CGFloat(-20)
            }
        }
    }
    var typeResponder: AreaTypeResponder!
    var gameDifficulty: GameDifficulty!
    var readyToSpawn: Bool!
    var difficultyTimer: Timer?
    let packageFactory = PackageFactory()
    var hearts = [HeartNode]()
    var powerUpHolder: PowerUpHolder!
    var powerUps = [PowerUpBubble]()
    var comboPowerUpMediator: ComboPowerUpMediator!
    var lives: Int = 3 { 
        didSet {
            if lives != 3 && oldValue > lives{
                loseAHeart()
                if lives == 0 {
                    gameOver()
                }
            }
        }
    }
    var allPerfect = false
    
    override func didMove(to view: SKView) {
        readyToSpawn = false
        initiateGame()
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !checkForGameOver() {
            boxesInPlay.forEach({
                $0.animate()
                destroyOutOfBoundsBoxes(boxToDestroy: $0)
            })
            if readyToSpawn {
                addBoxToPlay()
            }
            
            if packageFactory.packagesLeftToSpawn <= 0 && boxesInPlay.count == 0 {
                conveyorBelt.switchPositionOfFireZone(forScene: self)
                packageFactory.restoreAvailablePackagesCount()
                gameDifficulty.switchSide()
                addBoxToPlay()
            }
        }
    }
    
    override func initiateGame() {
        super.initiateGame()
        addHeartsToScene()
        gameDifficulty = GameDifficulty()
        powerUpHolder = PowerUpHolder()
        comboPowerUpMediator = ComboPowerUpMediator(requiredHitsForGeneration: 2, powerUpHolder: powerUpHolder, comboLabel: self.comboLabel)
    }
    
    override func handleButtonPress(gameButton: GameButtonContainer) {
        let buttonColor = gameButton.colorType
        let boxInArea = getBoxToCheck()
        
        if let boxToCheckForColor = boxInArea {
            boxInAreaRoutine(boxToCheckForColor: boxToCheckForColor, buttonColor: buttonColor)
        } else {
            typeResponder.changeSprite(forAreaType: nil)
            lives = lives - 1
            dropCombo()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            let tappedNodes = nodes(at: touchLocation)
            let powerUpBubbleHit = tappedNodes.compactMap({ $0 as? PowerUpBubble }).first
                
            if let powerUpPressed = powerUpBubbleHit, powerUpPressed.isClickable() {
                handlePowerUpPressed(powerUpBubble: powerUpPressed)
            }
        }
    }
    
    func getBoxToCheck() -> (PackageContainer, CorrectAreaType)? {
        var boxInArea: (PackageContainer, CorrectAreaType)?
        boxesInPlay.forEach({
            let boxPositionForConveyor = convert($0.position, to: conveyorBelt)
            if let area = conveyorBelt.decideBoxArea(boxWidth: $0.getBoxWidth(), pointToCheck: boxPositionForConveyor) {
                boxInArea = ($0,area)
            }
        })
        return boxInArea
    }
    
    func boxInAreaRoutine(boxToCheckForColor: (PackageContainer, CorrectAreaType), buttonColor: ButtonColors) {
        if (boxToCheckForColor.0.colorType == buttonColor || boxToCheckForColor.0.colorType == .colorless) {
            let positionOfBox = convert(boxToCheckForColor.0.position, to: self)
            if allPerfect {
                handleBoxInArea(area: .perfect, boxLocation: positionOfBox)
            } else {
                handleBoxInArea(area: boxToCheckForColor.1, boxLocation: positionOfBox)
            }
            removeBoxFromPlay(boxToRemove: boxToCheckForColor.0)
        } else {
            typeResponder.changeSprite(forAreaType: nil)
            lives = lives - 1
            dropCombo()
        }
    }
    
    func removeBoxFromPlay(boxToRemove: PackageContainer) {
        boxToRemove.removeFromParent()
        let boxIndex = boxesInPlay.index(of: boxToRemove)
        boxesInPlay.remove(at: boxIndex!)
    }
    
    override func addLabelsToScene() {
        super.addLabelsToScene()
        
        typeResponder = AreaTypeResponder()
        addChild(typeResponder)
    }
    override func startGame() {
        super.startGame()
        difficultyTimer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(increaseDifficulty), userInfo: nil, repeats: true)
        readyToSpawn = true
    }
    
    func prepareNextSpawn() {
        readyToSpawn = false
        DispatchQueue.main.asyncAfter(deadline: .now() + gameDifficulty.getTimeInterval()) {
            if self.packageFactory.packagesLeftToSpawn >= 0 {
                self.readyToSpawn = true
            }
        }
    }
    
    func increaseAllBoxSpeed() {
        boxesInPlay.forEach({
            $0.physicsBody?.velocity = CGVector(dx: gameDifficulty.getSpeed(), dy: -100)
        })
    }
    
    func handleBoxInArea(area: CorrectAreaType, boxLocation: CGPoint) {
        typeResponder.changeSprite(forAreaType: area)
        let behaviour = area.behaviourForType()
        scoreLabel.changeScore(action: .increase, areaBehaviour: area)
        if(behaviour.1) {
            dropCombo()
        }else{
            comboLabel.update(action: .increase)
            if comboPowerUpMediator.checkIfCanGivePowerUp() {
                if let powerUp = comboPowerUpMediator.generateAPowerUp() {
                    powerUps.append(powerUp.0)
                    addPowerUpSpriteToScene(powerUpSprite: powerUp.0 , boxPosition: boxLocation, locationToGoTo: powerUp.1)
                }
            }
            comboCharacterMediator.checkForDazzle()
        }
        if(comboLabel.checkForScoreIncreasePossibility()) {
            scoreLabel.increaseBaseScore()
        }
    }
    
    func addHeartsToScene() {
        for i in 0...2 {
            let heart = HeartNode(imageNamed: "heartFull")
            heart.zPosition = 5
            heart.position = CGPoint(x: 100+i*64, y: 680)
            hearts.append(heart)
            addChild(heart)
        }
    }
    
    func loseAHeart() {
        var foundFullHeart = false
        hearts.forEach { (heart) in
            if heart.heartState == .active && !foundFullHeart {
                heart.animate()
                heart.changeHeartState()
                foundFullHeart = true
            }
        }
    }
    
    func checkForGameOver() -> Bool {
        if lives == 0 {
            return true
        }
        return false
    }
    
    func addPowerUpSpriteToScene(powerUpSprite: PowerUpBubble, boxPosition position: CGPoint, locationToGoTo: CGPoint) {
        powerUpSprite.position = position
        addChild(powerUpSprite)
        powerUpSprite.addToSceneAnimation(to: locationToGoTo)
    }
    
    func destroyOutOfBoundsBoxes(boxToDestroy: PackageContainer) {
        if conveyorBelt.fireZone.isRight {
            if(boxToDestroy.position.x - CGFloat(boxToDestroy.getBoxWidth()/2) > conveyorBelt.xPointToCheckForDestruction + OUTSIDE_BOUNDS_DEGREE_ERROR) {
                carryOutDestruction(boxToDestroy: boxToDestroy)
            }
        } else {
            if(boxToDestroy.position.x - CGFloat(boxToDestroy.getBoxWidth()/2) < conveyorBelt.xPointToCheckForDestruction + OUTSIDE_BOUNDS_DEGREE_ERROR) {
                carryOutDestruction(boxToDestroy: boxToDestroy)
            }
        }
    }
    
    func carryOutDestruction(boxToDestroy: PackageContainer) {
        dropCombo()
        if !checkForGameOver() {
            lives = lives - 1
        }
        typeResponder.changeSprite(forAreaType: nil)
        removeBoxFromPlay(boxToRemove: boxToDestroy)
    }
    
    func changeToColorless() {
        boxesInPlay.forEach {
            $0.switchToColorless()
        }
        packageFactory.switchToColorless()
    }
    
    func changeToAllPerfect() {
        allPerfect = true
        Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(restoreAllPerfect), userInfo: nil, repeats: false)
    }
    
    @objc func restoreAllPerfect() {
        allPerfect = false
    }
    
    func canAddExtraLife()  -> Bool {
        if lives != 3 {
            return true
        }
        return false
    }
    
    func giveALifeBack() {
        if canAddExtraLife() {
            var changedEmptyLife = false
            for i in 0..<hearts.count {
                if hearts[i].heartState == .destroyed && !changedEmptyLife {
                    hearts[i].animate()
                    hearts[i].changeHeartState()
                    lives = lives + 1
                    changedEmptyLife = true
                }
            }
        }
    }
    
    func handlePowerUpPressed(powerUpBubble: PowerUpBubble) {
        powerUpBubble.powerUp.getType().getFunctionalityForType(gameScene: self)
        powerUpHolder.markSpotAsEmpty(index: powerUpBubble.indexInHolder)
        powerUpBubble.removeFromParent()
        let indexToRemoveAt = powerUps.index(of: powerUpBubble)!
        powerUps.remove(at: indexToRemoveAt)
    }
    
    @objc func addBoxToPlay() {
        prepareNextSpawn()
        var boxToAdd: PackageContainer
        if packageFactory.spawnLeft {
            boxToAdd = packageFactory.createPackage(at: CGPoint(x:0,y:300), withSpeed: CGVector(dx: gameDifficulty.getSpeed(), dy: -100))
        } else {
            boxToAdd = packageFactory.createPackage(at: CGPoint(x: self.scene!.size.width, y: 300), withSpeed: CGVector(dx: gameDifficulty.getSpeed(), dy: -100))
        }
        addChild(boxToAdd)
        boxesInPlay.append(boxToAdd)
    }
    
    @objc func increaseDifficulty() {
        gameDifficulty.increaseDifficulty()
        increaseAllBoxSpeed()
    }
}

