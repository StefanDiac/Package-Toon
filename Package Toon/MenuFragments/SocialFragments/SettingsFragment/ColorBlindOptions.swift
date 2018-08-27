//
//  ColorBlindOptions.swift
//  Package Toon
//
//  Created by Air_Book on 7/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation
import UIKit

enum ColorBlindOption {
    case noColorBlind
    case protan
    case deutan
    case tritan
    
    func caseAsString() -> String {
        switch self {
        case .noColorBlind:
            return "None"
        case .protan:
            return "Protan"
        case .deutan:
            return "Deutan"
        case .tritan:
            return "Tritan"
        }
    }
    
    static func stringToCase(forCase: String) -> ColorBlindOption {
        switch forCase {
        case  "None":
            return .noColorBlind
        case "Protan":
            return .protan
        case "Deutan":
            return .deutan
        case "Tritan":
            return .tritan
        default:
            return .noColorBlind
        }
    }
    
    static func redForColorBlindType(forType type: ColorBlindOption) -> UIColor {
        switch type {
        case .noColorBlind:
            return ColorConstants.RED_PASTEL
        case .protan:
            return ColorConstants.RED_PROTAN
        case .deutan:
            return ColorConstants.RED_DEUTERAN
        case .tritan:
            return ColorConstants.RED_TRITAN
        }
    }
    
    static func blueForColorBlindType(forType type: ColorBlindOption) -> UIColor {
        switch type {
        case .noColorBlind:
            return ColorConstants.BLUE_PASTEL
        case .protan:
            return ColorConstants.BLUE_PROTAN
        case .deutan:
            return ColorConstants.BLUE_DEUTERAN
        case .tritan:
            return ColorConstants.BLUE_TRITAN
        }
    }
    
    static func greenForColorBlindType(forType type: ColorBlindOption) -> UIColor {
        switch type {
        case .noColorBlind:
            return ColorConstants.GREEN_PASTEL
        case .protan:
            return ColorConstants.GREEN_PROTAN
        case .deutan:
            return ColorConstants.GREEN_DEUTERAN
        case .tritan:
            return ColorConstants.GREEN_TRITAN
        }
    }
    
    static func yellowForColorBlindType(forType type: ColorBlindOption) -> UIColor {
        switch type {
        case .noColorBlind:
            return ColorConstants.YELLOW_PASTEL
        case .protan:
            return ColorConstants.YELLOW_PROTAN
        case .deutan:
            return ColorConstants.YELLOW_DEUTERAN
        case .tritan:
            return ColorConstants.YELLOW_TRITAN
        }
    }
    
    static func purpleForColorBlindType(forType type: ColorBlindOption) -> UIColor {
        switch type {
        case .noColorBlind:
            return ColorConstants.PURPLE_PASTEL
        case .protan:
            return ColorConstants.PURPLE_PROTAN
        case .deutan:
            return ColorConstants.PURPLE_DEUTERAN
        case .tritan:
            return ColorConstants.PURPLE_TRITAN
        }
    }
}
