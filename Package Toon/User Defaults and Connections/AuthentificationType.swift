//
//  AuthentificationType.swift
//  Package Toon
//
//  Created by Air_Book on 6/22/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

enum AuthentificationType {
    case facebook
    case google
    case twitter
    
    static func buttonNameToType(buttonName: String) -> AuthentificationType {
        switch buttonName {
        case "facebookLogin":
            return .facebook
        default:
            return .facebook
        }
    }
    
    func typeToString() -> String {
        switch self {
        case .facebook:
            return "facebook"
        case .google:
            return "google"
        case .twitter:
            return "twitter"
        }
    }
    
    static func typeFromString(type: String?) -> AuthentificationType? {
        switch type {
        case "facebook":
            return .facebook
        case "google":
            return .google
        case "twitter":
            return .twitter
        default:
            return nil
        }
    }
}
