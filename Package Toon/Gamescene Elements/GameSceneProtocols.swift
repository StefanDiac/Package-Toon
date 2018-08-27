//
//  GameButtonProtocol.swift
//  Package Toon
//
//  Created by Air_Book on 3/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

protocol Animated {
    func animate()
}

protocol ColorType {
    var colorType: ButtonColors {get}
    init(colorType: ButtonColors)
}

protocol UpdatesText {
    var updateValue: Int {get}
    func update(action: LabelAction)
}


