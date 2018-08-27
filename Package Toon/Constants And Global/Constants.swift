//
//  Constants.swift
//  Package Toon
//
//  Created by Air_Book on 4/3/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit

struct ColorConstants {
    static let RED_PASTEL = UIColor(red: 1.0, green: 0.419, blue: 0.494, alpha: 1.0)
    static let BLUE_PASTEL =  UIColor(red: 0.42, green: 0.71, blue: 1.0, alpha: 1.0)
    static let GREEN_PASTEL = UIColor(red: 0.42, green: 1.0, blue: 0.592, alpha: 1.0)
    static let YELLOW_PASTEL = UIColor(red: 0.941, green: 1.0, blue: 0.42, alpha: 1.0)
    static let PURPLE_PASTEL = UIColor(red: 0.88, green: 0.42, blue: 1.0, alpha: 1.0)
    static let RED_PROTAN = UIColor(red: 0.368, green: 0.243, blue: 0.122, alpha: 1.0)
    static let BLUE_PROTAN = UIColor(red: 0.0, green: 0.792, blue: 1.0, alpha: 1.0)
    static let GREEN_PROTAN = UIColor(red: 0.0, green: 0.675, blue: 0.192, alpha: 1.0)
    static let YELLOW_PROTAN = UIColor.white
    static let PURPLE_PROTAN = UIColor(red: 0.0, green: 0.054, blue: 0.192, alpha: 1.0)
    static let RED_DEUTERAN = ColorConstants.RED_PROTAN
    static let BLUE_DEUTERAN = ColorConstants.BLUE_PASTEL
    static let GREEN_DEUTERAN = UIColor(red: 0.2, green: 1.0, blue: 0.24, alpha: 1.0)
    static let YELLOW_DEUTERAN = UIColor.white
    static let PURPLE_DEUTERAN = UIColor.black
    static let RED_TRITAN = ColorConstants.RED_PASTEL
    static let BLUE_TRITAN = UIColor(red: 0.32, green: 0.51, blue: 1.0, alpha: 1.0)
    static let GREEN_TRITAN = ColorConstants.GREEN_PASTEL
    static let YELLOW_TRITAN = ColorConstants.YELLOW_PASTEL
    static let PURPLE_TRITAN = UIColor.black
    static let INVISIBLE = UIColor.clear
}

struct PackageTexturesImageNames {
    static let RED_INDICATOR = "packageIndicatorRedPastel"
    static let BLUE_INDICATOR = "packageIndicatorBluePastel"
    static let GREEN_INDICATOR = "packageIndicatorGreenPastel"
    static let YELLOW_INDICATOR = "packageIndicatorYellowPastel"
    static let PURPLE_INDICATOR = "packageIndicatorPurplePastel"
    static let COLORLESS_INDICATOR = "packageIndicatorColorlessPastel"
}

struct TimingConstant {
    //static let BOX_CORRECT_PARTICLE_TIMING = 
}

struct MenuScenePositionConstants {
    static let CENTER_OF_SCENE = CGPoint(x: 667, y: 375)
}

let GAME_IDENTIFIERS_STRING_LITERALS = ["discoHighscore", "rushHighscore", "5rushHighscore"]
