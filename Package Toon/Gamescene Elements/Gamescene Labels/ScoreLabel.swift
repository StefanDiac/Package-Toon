//
//  ScoreLabel.swift
//  Package Toon
//
//  Created by Air_Book on 4/5/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

class ScoreLabel: SKLabelNode, UpdatesText {
    
    var updateValue: Int{
        didSet{
            if updateValue != 0 {
                self.text = "Score: \(updateValue)"
            }
        }
    }
    private var baseScore: Int
    private var dynamicScoreValue: Int
    private var isDoubleScoreOn: Bool
    
    func update(action: LabelAction) {
        switch action {
        case .increase:
            if(!isDoubleScoreOn) {
                updateValue = updateValue + dynamicScoreValue
            } else {
                updateValue = updateValue + 2*dynamicScoreValue
            }
            break;
        case .reset:
            baseScore = 10
            break;
        }
    }
    
    func changeScore(action: LabelAction, areaBehaviour: CorrectAreaType?) {
        if let behaviour = areaBehaviour {
            dynamicScoreValue = Int(Double(baseScore)*behaviour.behaviourForType().0)
            switch(behaviour) {
            case .perfect:
                update(action: .increase)
                break;
            case .good:
                update(action: .increase)
                break;
            case .ok:
                update(action: .increase)
                break;
            }
        } else {
            update(action: .reset)
        }
    }
    
    override init() {
        updateValue = 0
        baseScore = 10
        dynamicScoreValue = 0
        isDoubleScoreOn = false
        super.init()
        fontName = "AvenirNext-Heavy"
        fontSize = 34
        zPosition = 1
        position = CGPoint(x: 1000, y: 680)
        text = "Score: 0"
        horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
    }
    
    func increaseBaseScore() {
        baseScore = baseScore + 5
    }
    
    func changeDoubleScoreState() {
        isDoubleScoreOn = !isDoubleScoreOn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
