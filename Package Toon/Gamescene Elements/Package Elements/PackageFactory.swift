//
//  PackageFactory.swift
//  Package Toon
//
//  Created by Air_Book on 3/24/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit
import GameplayKit

class PackageFactory {
    private var colorlessPackagesRemainingToSpawn: Int = 0
    private var _packagesLeftToSpawn: Int
    private let randomDistribution = GKRandomDistribution.init(lowestValue: 4, highestValue: 7)
    private var _spawnLeft = true
    var spawnLeft: Bool {
        get {
            return _spawnLeft
        }
        set {
            _spawnLeft = newValue
        }
    }
    var packagesLeftToSpawn: Int {
        get {
            return _packagesLeftToSpawn
        }
    }
    init() {
        _packagesLeftToSpawn = randomDistribution.nextInt()
    }
    
    func createPackage(at point: CGPoint, withSpeed speedVector: CGVector) -> PackageContainer {
        let packageToAdd = PackageContainer(colorType: getColorForPackage())
        packageToAdd.configure()
        packageToAdd.position = point
        packageToAdd.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 75, height: 45))
        packageToAdd.physicsBody?.isDynamic = true
        packageToAdd.physicsBody?.velocity = speedVector
        packageToAdd.physicsBody?.linearDamping = 0
        packageToAdd.physicsBody?.friction = 0
        //packageToAdd.physicsBody?.collisionBitMask = 0
        _packagesLeftToSpawn = _packagesLeftToSpawn - 1
        return packageToAdd
    }
    
    private func getColorForPackage() -> ButtonColors {
        if colorlessPackagesRemainingToSpawn == 0 {
            return ButtonColors.generateRandomColor()
        } else {
            colorlessPackagesRemainingToSpawn = colorlessPackagesRemainingToSpawn - 1
            return ButtonColors.colorless
        }
    }
    
    func switchToColorless() {
        colorlessPackagesRemainingToSpawn = 5
    }
    
    func restoreAvailablePackagesCount() {
        _packagesLeftToSpawn = randomDistribution.nextInt()
        _spawnLeft = !_spawnLeft
    }
}
