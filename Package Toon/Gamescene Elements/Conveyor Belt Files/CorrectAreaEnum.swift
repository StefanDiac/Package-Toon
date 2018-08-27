//
//  CorrectAreaEnum.swift
//  Package Toon
//
//  Created by Air_Book on 3/28/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

enum CorrectAreaType {
    case perfect
    case good
    case ok
    
    func behaviourForType() -> (Double, Bool) {
        switch self {
        case .perfect:
            return (1.0,false)
        case .good:
            return(0.5,false)
        case .ok:
            return(0.1,true)
        }
    }
    
    func typeAsString() -> String {
        switch self {
        case .perfect:
            return "Perfect"
        case .good:
            return "Good"
        case .ok:
            return "Ok"
        }
    }
}
