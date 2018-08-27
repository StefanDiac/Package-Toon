//
//  FragmentActionsProtocol.swift
//  Package Toon
//
//  Created by Air_Book on 6/22/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

protocol MenuFragment{
    var callerScene: SKScene {get}
    func handleButtonPress(callerScene: MenuScene, at location: CGPoint)
}

protocol FragmentWithTextField{
    var isEditing: Bool { get set }
    func handleTextChangeWithValue(newValue: String)
    func handleTextChangeWithEmptyInput()
    func switchEditMode()
    func removeTextFieldFromFragment()
}

protocol FragmentSwitches {
    func createFragmentSwitcherHitbox(toBeDisplayedAt location: CGPoint, boxSize: CGSize) -> SKSpriteNode
    func getLocationOfFragmentSwitcher(forBoxSize boxSize: CGSize, backgroundSize: CGSize) -> (CGPoint, CGSize)
}

extension FragmentSwitches {
    func createFragmentSwitcherHitbox(toBeDisplayedAt location: CGPoint, boxSize: CGSize) -> SKSpriteNode {
        let hitboxRectangle = SKSpriteNode(texture: nil, color: UIColor.clear, size: boxSize)
        hitboxRectangle.position = location
        hitboxRectangle.zPosition = 3
        return hitboxRectangle
    }
}

