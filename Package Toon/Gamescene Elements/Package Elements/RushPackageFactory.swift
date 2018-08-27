//
//  RushPackageFactory.swift
//  Package Toon
//
//  Created by Air_Book on 7/7/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit
import GameplayKit

class RushPackageFactory {
    let LEFT_X_PACKAGE_POSITIONS: [CGFloat]
    let RIGHT_X_PACKAGE_POSITIONS: [CGFloat]
    static let MAXIMUM_PACKAGES_ON_SCREEN = 5
    private var _packagesLeftToSpawn: Int
    private let randomDistribution = GKRandomDistribution.init(lowestValue: 5, highestValue: 9)
    private var _rightSpawning: Bool = true
    var packagesLeftToSpawn: Int {
        get {
            return _packagesLeftToSpawn
        }
    }
    var rightSpawning: Bool {
        get {
            return _rightSpawning
        }
    }
    
    func createRandomPackage() -> PackageContainer {
            let packageToAdd = PackageContainer(colorType: ButtonColors.generateRandomColor())
            packageToAdd.zPosition = 1
            _packagesLeftToSpawn = _packagesLeftToSpawn - 1
            return packageToAdd
    }
    
    func getXCoordsForPackage(withPosition position: Int) -> CGFloat{
        if _rightSpawning {
            return LEFT_X_PACKAGE_POSITIONS[position]
        } else {
            return RIGHT_X_PACKAGE_POSITIONS[position]
        }
    }
    
    func switchSpawn() {
        _rightSpawning = !_rightSpawning
        _packagesLeftToSpawn = randomDistribution.nextInt()
    }
    
    init(startingXPositionForSpawning position: CGFloat) {
        var leftLocations = [CGFloat]()
        var rightLocations = [CGFloat]()
        for i in 0..<RushPackageFactory.MAXIMUM_PACKAGES_ON_SCREEN {
            if i == 0 {
                leftLocations.append(position)
                rightLocations.append(position)
            } else {
                leftLocations.insert(leftLocations[0] - 150, at: 0)
                rightLocations.insert(rightLocations[0] + 150, at: 0)
            }
        }
        LEFT_X_PACKAGE_POSITIONS = leftLocations
        RIGHT_X_PACKAGE_POSITIONS = rightLocations
        _packagesLeftToSpawn = randomDistribution.nextInt()
    }
}
