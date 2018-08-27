//
//  UIScreenExtension.swift
//  Package Toon
//
//  Created by Air_Book on 7/11/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit

extension UIScreen {
    enum SizeType: CGFloat {
        case unknown = 0.0
        case iphone5_SE = 1136.0
        case iphone6_6s_7_8 = 1334
        case iphonePlus = 1920
    }
    
    var sizeType: SizeType {
        let height = nativeBounds.height
        switch height {
        case 1136:
            return .iphone5_SE
        case 1334:
            return .iphone6_6s_7_8
        case 1920, 2208:
            return .iphonePlus
        default:
            return .unknown
        }
    }
}
