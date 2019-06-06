//
//  MultiplayerGameViewController.swift
//  Matched
//
//  Created by kirsty darbyshire on 25/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit
import UIKit


class MultiplayerGameViewController: UIViewController, Storyboarded, MCSessionDelegate {
    var scene: MultiplayerGameScene!
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            print("starting a multiplayer game with \(peerID.displayName)")
            
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
        
    }
    
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        
    }
    
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        DispatchQueue.main.async { [weak self] in
            print("yay! we have data at the host: \(data) from \(peerID.displayName)")
            
            let message = String(decoding: data, as: UTF8.self)
            print("server got the message: \(message)")
            let stringBits = message.components(separatedBy: [" "])
            if stringBits[0] == "reveal" {
                self?.scene.revealCard(number: stringBits[1])
            } else if stringBits[0] == "conceal" {
                self?.scene.concealCard(number: stringBits[1])
            } else if stringBits[0] == "remove" {
                self?.scene.removeCard(number: stringBits[1])
            } else if stringBits[0] == "endturn" {
                self?.scene?.nextPlayer()
                //self?.scene.isUserInteractionEnabled = SessionManager.shared.newPlayer()
            }
        }
    }
    
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("frame: \(view.frame)")
        print("bounds: \(view.bounds)")
        print(view.subviews)
        
        SessionManager.shared.session.delegate = self
        
        
        //            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(restart))
        //            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    }
    
    // this is just a debugging thing
    @IBAction func seeWho(_ sender: Any) {
        
        guard let mcSession = SessionManager.shared.session else {
            print("session is wonky")
            return
        }
        print("session is ok!")
        print("there are \(mcSession.connectedPeers.count) connected peers")
        if mcSession.connectedPeers.count > 0 {
            print ("someone to play with!")
            let data = Data("message from host".utf8)
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                print("message not sent properly from host")
            }
        }
         print("server has state: \(scene.playerState)")
    }
    
    
    fileprivate func startGame() {
        title = "Multiplayer Matched Game"
        if let view = self.view as! SKView? {
            
            title = "Setting Up Matched Game"
            
            // TODO hmmm, these are at the wrong size :(
            scene = MultiplayerGameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill //.aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGame()
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func restart() {
        startGame()
    }
    
}
