//
//  ComboLabel.swift
//  Package Toon
//
//  Created by Air_Book on 4/3/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ComboLabel: SKLabelNode, UpdatesText {
    
    var updateValue: Int{
       didSet{
            if updateValue != 0 {
                    self.text = "x \(self.updateValue)"
            }
        }
    }
    
    override init() {
        updateValue = 0
        super.init()
        self.fontName = "AvenirNext-Heavy"
        self.fontSize = 48
        self.zPosition = 1
        self.text = ""
        self.position = CGPoint(x: 1100, y: 580)
        self.zRotation = CGFloat(-0.17)
    }

    func update(action: LabelAction) {
        switch(action) {
        case .increase:
            self.updateValue = self.updateValue + 1
            break;
        case .reset:
            self.updateValue = 0
            self.text = ""
            break;
        }
    }
    
    func checkForScoreIncreasePossibility()                                                                                                                                                                                                                                                                                                                                                                                                                                                                    -> Bool {
        if(updateValue >= 10 && updateValue % 10 == 0) {
            return true
        }
        return false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
