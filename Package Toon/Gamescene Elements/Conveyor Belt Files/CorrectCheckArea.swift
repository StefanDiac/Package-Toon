//
//  CorrectCheckArea.swift
//  Package Toon
//
//  Created by Air_Book on 3/28/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class CorrectCheckArea: SKSpriteNode {
    let type: CorrectAreaType
    let scoreMultiplier: Double
    let breakCombo: Bool
    private var _areaWidth: Double
    var hitBox: CGRect!
    
    var areaWidth: Double {
        get{
            return _areaWidth
        }
    }
    
    init(areaType type: CorrectAreaType, color: UIColor, size: CGSize, origin: CGPoint) {
        self.type = type
        let behaviour = self.type.behaviourForType()
        self.scoreMultiplier = behaviour.0
        self.breakCombo = behaviour.1
        self._areaWidth = Double(size.width)
        self.hitBox = CGRect(origin: origin, size: CGSize.getHitBoxSize(size: size))
        super.init(texture: nil, color: color, size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension CGSize {
    static func getHitBoxSize(size: CGSize) -> CGSize{
        return CGSize(width: size.width, height: size.height*10)
    }
}
