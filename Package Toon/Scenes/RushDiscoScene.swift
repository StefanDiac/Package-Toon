//
//  RushDiscoScene.swift
//  Package Toon
//
//  Created by Air_Book on 7/7/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class RushDiscoScene: GameScene {
    var packagesOnScreen = [PackageContainer]()
    var packageFactory: RushPackageFactory!
    var gameTimer: GameTimer!
    let startTime: Int
    let rewardTimeValue: Int
    let comboRequired: Int
    
    init(size: CGSize, startTime time: Int, rewardTimeValue: Int, comboRequired: Int) {
        self.startTime = time
        self.rewardTimeValue = rewardTimeValue
        self.comboRequired = comboRequired
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        initiateGame()
        conveyorBelt.zPosition = 3
        setZoneForConveyorBelt()
        packageFactory = RushPackageFactory(startingXPositionForSpawning: conveyorBelt.position.x)
        addInitialPackages()
        gameTimer = GameTimer(startTime: startTime)
        gameTimer.position = CGPoint(x: 667, y: 650)
        gameTimer.zPosition = 5
        addChild(gameTimer)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if !isGameOver {
           packagesOnScreen.forEach({
                $0.animate()
            })
        }
        if gameTimer.gameTimerValue <= 0 && !isGameOver {
            gameOver()
        }
    }
    
    override func gameOver() {
        super.gameOver()
        gameTimer.removeAllActions()
    }
    
    override func startGame() {
        super.startGame()
        gameTimer.startTimer()
    }
    
    override func handleButtonPress(gameButton: GameButtonContainer) {
        if packagesOnScreen.count == 0 {
            gameOver()
        } else {
            if gameButton.colorType == packagesOnScreen[packagesOnScreen.count - 1].colorType {
                scoreLabel.changeScore(action: .increase, areaBehaviour: .perfect)
                comboLabel.update(action: .increase)
                checkForHandingOutReward()
                if packageFactory.packagesLeftToSpawn == 0 {
                    boxRepositioningWithoutBoxesRemaining()
                } else {
                    boxRepositioningWithBoxesRemaining()
                }
                if packageFactory.packagesLeftToSpawn == 0 && packagesOnScreen.count == 0 {
                    conveyorBelt.switchPositionOfFireZone(forScene: self)
                    packageFactory.switchSpawn()
                    addInitialPackages()
                }
            } else {
                gameOver()
            }
        }
    }
    
    func setZoneForConveyorBelt() {
        let gameOptions = GameOptionsManager()
        
        if !gameOptions.retriveRushZoneOption() && gameOptions.retriveGreenZoneOption() {
            conveyorBelt.perfectEmitter?.removeFromParent()
        } else if !gameOptions.retriveRushZoneOption() {
            conveyorBelt.perfectArea.color = .clear
        }
    }
    
    func boxRepositioningWithBoxesRemaining() {
        for i in stride(from: packagesOnScreen.count-1, to: 0, by: -1) {
            if i != packagesOnScreen.count - 1 && i != 0 {
                packagesOnScreen[i].position = CGPoint(x: packageFactory.getXCoordsForPackage(withPosition: i), y: conveyorBelt.position.y + CGFloat(24))
            } else {
                packagesOnScreen[i].removeFromParent()
                packagesOnScreen.remove(at: i)
                let replacingPackage = packageFactory.createRandomPackage()
                replacingPackage.configure()
                replacingPackage.position = CGPoint(x: packageFactory.getXCoordsForPackage(withPosition: 0), y: conveyorBelt.position.y + CGFloat(24))
                packagesOnScreen.insert(replacingPackage, at: 0)
                addChild(replacingPackage)
                packagesOnScreen[i].position = CGPoint(x: packageFactory.getXCoordsForPackage(withPosition: i), y: conveyorBelt.position.y + CGFloat(24))
            }
        }
    }
    
    func boxRepositioningWithoutBoxesRemaining() {
        packagesOnScreen[packagesOnScreen.count - 1].removeFromParent()
        packagesOnScreen.remove(at: packagesOnScreen.count - 1)
        for i in 0..<packagesOnScreen.count {
            packagesOnScreen[i].position = CGPoint(x: packageFactory.getXCoordsForPackage(withPosition: RushPackageFactory.MAXIMUM_PACKAGES_ON_SCREEN - packagesOnScreen.count + i), y: conveyorBelt.position.y + CGFloat(24))
        }
    }
    
    func checkForHandingOutReward() {
        if comboRequired % comboLabel.updateValue == 0 && comboLabel.updateValue != 0 {
            giveReward()
        }
    }
    
    func giveReward() {
        gameTimer.gameTimerValue = gameTimer.gameTimerValue + rewardTimeValue
    }
    
    func addInitialPackages() {
        for i in 0..<RushPackageFactory.MAXIMUM_PACKAGES_ON_SCREEN {
            let newPackage = packageFactory.createRandomPackage()
            newPackage.configure()
            packagesOnScreen.append(newPackage)
            print(newPackage.getBoxWidth())
            newPackage.position = CGPoint(x: packageFactory.getXCoordsForPackage(withPosition: i), y: conveyorBelt.position.y + CGFloat(24))
            addChild(newPackage)
        }
    }
}
