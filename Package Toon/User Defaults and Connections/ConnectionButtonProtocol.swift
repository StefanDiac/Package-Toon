//
//  ConnectionButtonProtocol.swift
//  Package Toon
//
//  Created by Air_Book on 6/22/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import Foundation

protocol ConnectionButton {
    var type: AuthentificationType { get set }
    func handleAuthentification(fromRegisterFragment fragment: SocialRegisterFragment)
}
