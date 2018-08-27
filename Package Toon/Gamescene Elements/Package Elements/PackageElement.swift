//
//  PackageElement.swift
//  Package Toon
//
//  Created by Air_Book on 3/20/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class PackageElement: SKSpriteNode {
    private var animationCycleFinished: Bool
    
    init(color: UIColor, size: CGSize) {
        self.animationCycleFinished = false
        super.init(texture: nil, color: color, size: size)
    }
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
         self.animationCycleFinished = false
        super.init(texture: texture, color: color, size: size)
    }
    
    func updateAnimationCycle() {
        self.animationCycleFinished = !self.animationCycleFinished
    }
    
    func getCurrentCycle() -> Bool {
        return self.animationCycleFinished
    }
    
    static func getTexture(forColor: ButtonColors) -> SKTexture {
        switch forColor {
        case .red:
            return SKTexture(imageNamed: PackageTexturesImageNames.RED_INDICATOR)
        case .blue:
            return SKTexture(imageNamed: PackageTexturesImageNames.BLUE_INDICATOR)
        case .green:
            return SKTexture(imageNamed: PackageTexturesImageNames.GREEN_INDICATOR)
        case .yellow:
            return SKTexture(imageNamed: PackageTexturesImageNames.YELLOW_INDICATOR)
        case .purple:
            return SKTexture(imageNamed: PackageTexturesImageNames.PURPLE_INDICATOR)
        case .colorless:
            return SKTexture(imageNamed: PackageTexturesImageNames.COLORLESS_INDICATOR)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
