//
//  AreaTypeResponder.swift
//  Package Toon
//
//  Created by Air_Book on 4/6/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class AreaTypeResponder: SKSpriteNode {
    
    init() {
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 400, height: 200))
        self.isHidden = true
        self.zPosition = 1
        self.position = CGPoint(x: 650, y: 650)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func changeSprite(forAreaType type: CorrectAreaType?) {
        self.isHidden = false
        resetSize()
        if let areaType = type {
            switch(areaType) {
            case .perfect:
                let changeToPerfect = SKAction.setTexture(SKTexture(imageNamed: "perfect"), resize: true)
                self.run(changeToPerfect)
                break;
            case .good:
                let changeToGood = SKAction.setTexture(SKTexture(imageNamed: "good"), resize: true)
                self.run(changeToGood)
                break;
            case .ok:
                let changeToOk = SKAction.setTexture(SKTexture(imageNamed: "ok"), resize: true)
                self.run(changeToOk)
                break;
            }
        } else {
            let changeToMiss = SKAction.setTexture(SKTexture(imageNamed: "miss"), resize: true)
            self.run(changeToMiss)
        }
        self.runHighlightAnimation()
    }
    
    private func resetSize() {
        self.size.width = self.size.width/2
        self.size.height = self.size.height/2
    }
    
    private func runHighlightAnimation() {
        let makeItBiggerWidth = SKAction.resize(toWidth: self.size.width*2, duration: 0.2)
        let makeItBiggerHeight = SKAction.resize(toHeight: self.size.height*2, duration: 0.2)
        let makeItBigger = SKAction.group([makeItBiggerWidth,makeItBiggerHeight])
        self.run(makeItBigger)
    }
}
