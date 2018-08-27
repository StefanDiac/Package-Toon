//
//  PackageContainer.swift
//  Package Toon
//
//  Created by Air_Book on 3/19/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

precedencegroup CompositionPrecedence {
    associativity: left
}

infix operator >>>>: CompositionPrecedence

func >>>> <T,U,V>(lhs: @escaping (T) -> U, rhs: @escaping (U) -> V) -> (T) -> V {
    return { rhs(lhs($0)) }
}

class PackageContainer: SKNode, Animated, ColorType {
    
    var state: PackageState
    var colorType: ButtonColors
    var currentlyRunningAnimation: Bool
    private static var BOX_WIDTH = 90
    
    func configure() {
        //TO DO: Refactor once I have sprites
        let box = PackageElement(color: .brown, size: CGSize(width: PackageContainer.BOX_WIDTH, height: 55))
        box.zPosition = 1
        box.position = CGPoint(x: 0, y: 0)
        addChild(box)
        
        let colorIndicator = PackageElement(texture: PackageElement.getTexture(forColor: self.colorType), color: UIColor.clear, size: CGSize(width: 46, height: 40))
        colorIndicator.zPosition = 2
        colorIndicator.name = "Indicator"
        colorIndicator.position = CGPoint(x: 0, y: 2.5)
        addChild(colorIndicator)
    }
    
     init(colorType: ButtonColors, hitCounter: Int) {
        self.colorType = colorType
        self.state = .idle
        self.currentlyRunningAnimation = false
        super.init()
    }
    
    required init(colorType: ButtonColors) {
        self.colorType = colorType
        self.state = .idle
        self.currentlyRunningAnimation = false
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animate() {
        if(!currentlyRunningAnimation) {
            let animationToRun = getCurrentStateForChild >>>> getAnimationForState
            var durationOfAnimation: Double = 0 
            self.children.compactMap({$0 as? PackageElement}).forEach({
                let animationAndDuration = animationToRun($0)
                durationOfAnimation = animationAndDuration.1
                let elementReference = $0
                DispatchQueue.main.async {
                    elementReference.run(animationAndDuration.0)
                }
            })
            DispatchQueue.main.asyncAfter(deadline: .now() + durationOfAnimation, execute: {
                self.changeCurrentlyRunning()
            })
            currentlyRunningAnimation = true
        }
    }
    
    func switchToColorless() {
        self.children.last!.run(SKAction.setTexture(SKTexture(imageNamed: PackageTexturesImageNames.COLORLESS_INDICATOR), resize: true))
        self.colorType = .colorless
    }
    
    func changeCurrentlyRunning() {
        currentlyRunningAnimation = false
    }
    
    func getCurrentStateForChild(child: PackageElement) -> (PackageState, PackageElement) {
        return (self.state, child)
    }
    
    func getAnimationForState(stateForChild tuple: (PackageState, PackageElement)) -> (SKAction,Double) {
        return tuple.0.animationToPerform(size: tuple.1.size)
    }
    
    func getBoxWidth() -> Int {
        return PackageContainer.BOX_WIDTH
    }
    
}
