//
//  GameViewController.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("frame: \(view.frame)")
        print("bounds: \(view.bounds)")
        print(view.subviews)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))

    }
    
    fileprivate func startGame() {
        if let view = self.view as! SKView? {
            
            title = "Matched Game"
            print("frame: \(view.frame)")
            print("bounds: \(view.bounds)")
            print("portrait?: \(UIApplication.shared.statusBarOrientation.isPortrait)")
            
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "GameScene") {
            let scene = GameScene(size: view.bounds.size)
            // view.frame.size
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .resizeFill //.aspectFill
            
            
            print(scene)
            
            // Present the scene
            view.presentScene(scene)
            //}
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print("framewill: \(view.frame)")
        print("boundswill: \(view.bounds)")
        
        startGame()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
//        if UIDevice.current.userInterfaceIdiom == .phone {
//            return .allButUpsideDown
//        } else {
//            return .all
//        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func restart() {
        startGame()
    }

}
