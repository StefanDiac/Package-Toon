//
//  ButtonColorEnum.swift
//  Package Toon
//
//  Created by Air_Book on 3/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation
import GameplayKit

enum ButtonColors {
    case red
    case blue
    case green
    case yellow
    case purple
    case colorless
    
    static func generateRandomColor() -> ButtonColors {
        let randomDistribution = GKRandomDistribution(lowestValue: 1, highestValue: 5)
        switch(randomDistribution.nextInt()) {
        case 1:
            return .red
        case 2:
            return .blue
        case 3:
            return .green
        case 4:
            return .yellow
        case 5:
            return .purple
        default:
            return .red
        }
    }
}
