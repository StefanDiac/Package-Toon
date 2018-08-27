//
//  FacebookLoginManager.swift
//  Package Toon
//
//  Created by Air_Book on 6/22/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import SpriteKit
import FacebookLogin
import FacebookCore
import FirebaseAuth

class FacebookLoginManager {
    static func generateLogInButton(at position: CGPoint) -> SKSpriteNode {
        let loginButton = FacebookLoginButton(type: .facebook)
        loginButton.position = position
        return loginButton
    }
    
    static func registerWithFacebook(viewController: UIViewController, fromRegisterFragment fragment: SocialRegisterFragment) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: viewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                fragment.changeErrorLabel(withErrorText: "Failed to authenticate user ! Please try again.")
                break;
            case .cancelled:
                fragment.changeErrorLabel(withErrorText: "User cancelled authentification")
                break;
            case .success( _,  _, let accessToken):
                FirebaseDAO.handleRegisterEvent(registerType: .facebook, token: accessToken, fromRegisterFragment: fragment)
            }
        }
    }
    
    private static func restoreAccessToken(viewController: UIViewController) {
        let loginManager = LoginManager()
        loginManager.logIn(readPermissions: [ .publicProfile, .email ], viewController: viewController) { loginResult in
            switch loginResult {
            case .failed(let error):
                print(error)
                break;
            case .cancelled:
                print("User cancelled login.")
                break;
            case .success( _,  _, _):
                print("Was able to restore the accessToken")
            }
        }
    }
    
    static func retriveAccessToken() -> AccessToken? {
        if let accessToken = AccessToken.current {
            return accessToken
        } else {
            AccessToken.refreshCurrentToken()
            let refreshedToken = AccessToken.current
            if let accessToken = refreshedToken {
                return accessToken
            } else {
                print("Could not refresh token due to a problem")
                return nil
            }
        }
    }
}
