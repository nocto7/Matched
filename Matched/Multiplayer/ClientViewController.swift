//
//  ClientViewController.swift
//  Matched
//
//  Created by kirsty darbyshire on 25/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit
import UIKit

class ClientViewController: UIViewController, Storyboarded, MCSessionDelegate {
    weak var coordinator: MainCoordinator?
    var scene: ClientGameScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("frame: \(view.frame)")
        print("bounds: \(view.bounds)")
        print(view.subviews)
        
        SessionManager.shared.session.delegate = self
        
        // startGame()
        
        // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))
        //navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
    }
    
//    @objc func showConnectionPrompt() {
//        coordinator?.connectToGame()
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGame()
    }
    
    fileprivate func startGame() {
        title = "Multiplayer Matched Game"
        if let view = self.view as! SKView? {
            
            title = "Setting Up Matched Game"
            
            scene = ClientGameScene(size: view.bounds.size)
            scene.scaleMode = .resizeFill //.aspectFill
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    @IBAction func seeWho(_ sender: Any) {
        guard let mcSession = SessionManager.shared.session else {
            print("client session is wonky")
            return
        }
        print("client session is ok!")
        print("there are \(mcSession.connectedPeers.count) connected peers")
        if mcSession.connectedPeers.count > 0 {
            print ("someone to play with!")
            let data = Data("message from client".utf8)
            do {
                try mcSession.send(data, toPeers: mcSession.connectedPeers, with: .reliable)
            } catch {
                print("message not sent properly from client")
            }
        }
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            print("starting a multiplayer game as a client with \(peerID.displayName)")
            
            
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
            print("yay! we have data at the client: \(data) from \(peerID.displayName)")
            
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([String].self, from: data) {
                print(decoded)
                self?.scene.setCards(cardNames: decoded)
            }
        }
    }
}
