//
//  FireZone.swift
//  Package Toon
//
//  Created by Air_Book on 7/6/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class FireZone: SKNode {
    private let fireZoneHitbox: SKSpriteNode
    private let fireZoneEmitter: SKEmitterNode?
    private var _isRight = true
    var isRight: Bool {
        get {
            return _isRight
        }
        set {
            _isRight = newValue
        }
    }
    
    init(sizeOfZone: CGSize) {
        fireZoneHitbox = SKSpriteNode(texture: nil, color: UIColor.clear, size: sizeOfZone)
        fireZoneEmitter = SKEmitterNode(fileNamed: "RedZoneFire")
        
        
        super.init()
        fireZoneHitbox.position = CGPoint(x: 0, y: 0)
        fireZoneHitbox.zPosition = 1
        addChild(fireZoneHitbox)
        if let fireZone = fireZoneEmitter {
            fireZone.particlePositionRange.dx = sizeOfZone.width
            addChild(fireZone)
        } else {
            fireZoneHitbox.color = .red
        }
    }
    
    func getFireZoneStartValue() -> CGPoint {
        if isRight {
            return CGPoint(x: -fireZoneHitbox.size.width/2, y: 0)
        } else {
            return CGPoint(x: fireZoneHitbox.size.width/2, y: 0)
        }
    }
    
    func switchPosition() {
        isRight = !isRight
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
