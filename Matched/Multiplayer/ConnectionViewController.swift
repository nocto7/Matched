//
//  ConnectionViewController.swift
//  Matched
//
//  Created by kirsty darbyshire on 25/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import UIKit

class ConnectionViewController: UIViewController, Storyboarded, MCBrowserViewControllerDelegate {
    weak var coordinator: MainCoordinator?
    
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    var mcSession: MCSession?
    var mcAdvertiserAssistant: MCAdvertiserAssistant?


    override func viewDidLoad() {
        super.viewDidLoad()

        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        //mcSession?.delegate = self
    }
    
    @IBAction func startHostingGame(_ sender: Any) {
        guard let mcSession = mcSession else { return }
        let mcBrowser = MCBrowserViewController(serviceType: "nocto-matched", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
        print("hosting")
        SessionManager.shared.setup(session: mcSession)
        
    }
    
   
    @IBAction func joinGame(_ sender: Any) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "nocto-matched", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
        print("joining")
        SessionManager.shared.setup(session: mcSession)
        coordinator?.multiplayerGameClient()
    }
    
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        print("browser view finished")
        dismiss(animated: true)
        // start hosting the game when the players are invited
        coordinator?.hostMultiplayerGame()
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
        print("browser view cancelled")
    }
    




}
