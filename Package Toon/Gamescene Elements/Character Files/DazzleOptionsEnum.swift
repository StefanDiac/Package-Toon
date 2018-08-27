//
//  DazzleOptionsEnum.swift
//  Package Toon
//
//  Created by Air_Book on 6/9/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

enum DazzleOption {
    case ok
    case dab
    case surf
    
    func provideImageNameForDazzle() -> String {
        switch self {
        case .ok:
            return "ok"
        case .dab:
            return "dab"
        case .surf:
            return "surf"
        }
    }
}
