//
//  SKShadowTextNode.swift
//  Package Toon
//
//  Created by Air_Book on 2/28/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class SKShadowTextNode: SKNode {
    func create(textToDisplay text: String, fontSize: CGFloat) {
        let textLabel = SKLabelNode(fontNamed: "Avenir-Black")
        textLabel.fontSize = fontSize
        textLabel.zPosition = 3
        textLabel.position = CGPoint(x: 0, y: 0)
        textLabel.text = text
        
        addChild(textLabel)
        
        for i in 0..<4 {
            let shadowLabel = SKLabelNode(fontNamed: "Avenir-Black")
            shadowLabel.fontSize = fontSize
            shadowLabel.zPosition = textLabel.zPosition - 1
            switch i {
            case 0:
                shadowLabel.position = CGPoint(x: -1, y: 0)
                break;
            case 1:
                shadowLabel.position = CGPoint(x: 0, y: -1)
                break;
            case 2:
                shadowLabel.position = CGPoint(x: 1, y: 0)
                break;
            case 3:
                shadowLabel.position = CGPoint(x: 0, y: 1)
                break;
            default:
                break;
            }
            
            shadowLabel.text = text
            shadowLabel.fontColor = .black
            addChild(shadowLabel)
        }
    }
    
    func updateText(text: String) {
        children.forEach { (node) in
            if let labelNode = node as? SKLabelNode {
                labelNode.text = text
            }
        }
    }
}
