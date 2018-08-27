//
//  CharacterStateProtocol.swift
//  Package Toon
//
//  Created by Air_Book on 6/8/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

protocol CharacterState {
    func provideStateAnimation() -> SKAction
    func handleStateChange()
}
