//
//  GameViewController.swift
//  Package Toon
//
//  Created by Air_Book on 2/27/18.
//  Copyright © 2018 Stefan Diac. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    static var controllerReference: UIViewController? = nil
    static let friendsCacheReference = NSCache<NSString, FriendsCache>()
    static let playerInfoCacheReference = NSCache<NSString, ProfileCache>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GameViewController.controllerReference = self
        
        if !UserDefaults.standard.bool(forKey: "initialSettingsMade") {
            UserDefaults.standard.set(true, forKey: "rushZone")
            UserDefaults.standard.set(true, forKey: "green")
            UserDefaults.standard.set(true, forKey: "initialSettingsMade")
        }
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'MenuScene.sks'
            if let scene = SKScene(fileNamed: "MenuScene"){
                
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

extension Array {
    func split() -> (left: [Element], right: [Element]) {
        let count = self.count
        let half = count/2
        let leftSplit = self[0..<half]
        let rightSplit = self[half..<count]
        return (left: Array(leftSplit), right: Array(rightSplit))
    }
}
