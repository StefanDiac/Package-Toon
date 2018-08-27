//
//  ConveyorBelt.swift
//  Package Toon
//
//  Created by Air_Book on 3/28/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ConveyorBelt: SKNode {
    let belt: SKSpriteNode
    let perfectArea: CorrectCheckArea
    let goodArea: CorrectCheckArea
    let okArea: CorrectCheckArea
    let perfectEmitter: SKEmitterNode?
    var fireZone: FireZone
    var xPointToCheckForDestruction: CGFloat!
    
    func configure(at position: CGPoint, forScene scene: GameScene) {
        self.position = position
        
        addChild(belt)
        addChild(perfectArea)
        addChild(goodArea)
        addChild(okArea)
        addChild(fireZone)
        xPointToCheckForDestruction = getFirezonePosition(relativeToScene: scene).x
    }
    
    override init() {
        belt = SKSpriteNode(color: .blue, size: CGSize(width: 1600, height: 10))
        belt.zPosition = 2
        belt.position = CGPoint(x: 0, y: 0)
        belt.physicsBody = SKPhysicsBody(rectangleOf: belt.size)
        belt.physicsBody?.isDynamic = false
        
        let xLocationToPlaceAreas = 0
        
        let perfectAreaPosition = CGPoint(x: xLocationToPlaceAreas, y:10)
        perfectEmitter = SKEmitterNode(fileNamed: "PerfectZoneEmitter")
        perfectArea = CorrectCheckArea(areaType: .perfect, color: .clear, size: CGSize(width: 120, height: 15), origin: perfectAreaPosition)
        perfectArea.zPosition = 5
        perfectArea.position = perfectAreaPosition
        
        let goodAreaPosition = CGPoint(x: xLocationToPlaceAreas, y: 10)
        goodArea = CorrectCheckArea(areaType: .good, color: .clear, size: CGSize(width: 150, height: 15), origin: goodAreaPosition)
        goodArea.zPosition = 4
        goodArea.position = goodAreaPosition
        
        let okAreaPosition = CGPoint(x: xLocationToPlaceAreas, y: 10)
        okArea = CorrectCheckArea(areaType: .ok, color: .clear, size: CGSize(width: 190, height: 15), origin: okAreaPosition)
        okArea.zPosition = 3
        okArea.position = okAreaPosition
        
        let sizeOfFirezone = CGSize(width: belt.size.width/2 - okArea.size.width/2, height: 50)
        fireZone = FireZone(sizeOfZone: sizeOfFirezone)
         fireZone.position = CGPoint(x: belt.size.width/4 + okArea.size.width/4, y: 10)
        fireZone.zPosition = 2
        super.init()
        if let perfectParticles = perfectEmitter, checkIfUserWantsParticles() {
            perfectParticles.zPosition = 7
            perfectParticles.particlePositionRange.dx = 120
        } else {
            perfectArea.color = .green
        }
    }
    
    func checkIfUserWantsParticles() -> Bool {
        let gameOptions = GameOptionsManager()
        return gameOptions.retriveGreenZoneOption()
    }
    
    func decideBoxArea(boxWidth: Int, pointToCheck point: CGPoint) -> CorrectAreaType? {
        if let perfectType = checkForAreaType(boxWidth: boxWidth, pointToCheck: point, areaToCheck: perfectArea) {
            return perfectType
        } else if let goodType = checkForAreaType(boxWidth: boxWidth, pointToCheck: point, areaToCheck: goodArea) {
            return goodType
        } else if let okType = checkForAreaType(boxWidth: boxWidth, pointToCheck: point, areaToCheck: okArea) {
            return okType
        } else {
            return nil
        }
    }
    
    func checkForAreaType(boxWidth: Int, pointToCheck point: CGPoint ,areaToCheck: CorrectCheckArea) -> CorrectAreaType? {
            let widthOfAcceptedBox = Double(boxWidth) * PackageDiscoScene.permittedDegreeOfError
            let pointDifference = abs(areaToCheck.position.x - point.x)
            if (pointDifference < CGFloat(areaToCheck.areaWidth/2 - widthOfAcceptedBox/2)) {
                return areaToCheck.type
            }
            return nil
    }
    
    func getFirezonePosition(relativeToScene: GameScene) -> CGPoint {
        let positionOfFirezoneInNode = convert(fireZone.getFireZoneStartValue(), from: fireZone)
        let positionToScene = convert(positionOfFirezoneInNode, to: relativeToScene)
        return positionToScene
    }
    
    func switchPositionOfFireZone(forScene scene: GameScene) {
        fireZone.switchPosition()
        fireZone.position.x = 0 - fireZone.position.x
        xPointToCheckForDestruction = getFirezonePosition(relativeToScene: scene).x
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
