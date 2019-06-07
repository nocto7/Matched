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
    @IBOutlet var turnLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("frame: \(view.frame)")
        print("bounds: \(view.bounds)")
        print(view.subviews)
        
        SessionManager.shared.session.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startGame()
    }
    
    fileprivate func startGame() {
        title = "Multiplayer Matched Game"
        if let view = self.view as! SKView? {
            
            title = "Matched Game Client"
            
            scene = ClientGameScene(size: view.bounds.size)
            scene.controller = self
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
        print("client has state: \(scene.playerState)")
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
            let decoder = JSONDecoder()
            if let gameMessage = try? decoder.decode(GameMessage.self, from: data) {
                print ("we have received a GameMessage! \(gameMessage)")
                switch gameMessage {
                case .setup(let cards):
                    self?.scene.setCards(cardTypes: cards)
                    return
                case .reveal(let card):
                    self?.scene.revealCard(number: card)
                    return
                case .conceal(let card):
                    self?.scene.concealCard(number: card)
                    return
                case .remove(let card):
                    self?.scene.removeCard(number: card)
                    return
                case .endturn:
                    self?.scene.makeInactivePlayer()
                    return
                case .yourturn:
                    self?.scene.makeActivePlayer()
                    return
                }
            }
        }
    }
}
