//
//  GameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit

class MultiplayerGameScene: BaseGameScene {

    var level = 3 // start multiplayer game at higher level
    
    override func didMove(to view: SKView) {
        playerState = PlayerState(mode: .multi, status: .unknown, role: .server)
        
        let items = (level + 1) * 4
        level(items: items)
    }
    
    
    func level(items: Int) {
        ColourManager.shared.changeColour()
        // this animates changing the background colour
        run(SKAction.colorize(with: UIColor(cgColor: ColourManager.shared.palest), colorBlendFactor: 1.0, duration: 1.5))
        
        let grid = CardGridInfo(items: items, windowSize: self.size)
        
        var cardTypes = CardGenerator.shared.getNewCardNames(number: items / 2)
        print(cardTypes)
        let cardTypes2 = cardTypes // copy the array
        for cardType in cardTypes2 {
            // use higher sequence numbers
            var cardTypeCopy = cardType
            cardTypeCopy.sequenceNumber += items / 2
            cardTypes.append(cardTypeCopy)
        }
        //cardTypes += cardTypes // duplicate each card
    
        cardTypes.shuffle() // make sure everyone has the same shuffle
        
        isUserInteractionEnabled = false
        
        // now tell the clients about the cards too
        sendGameToClients(cards: cardTypes)
        
        setUpCards(cardTypes, grid)
        pickPlayer()
        
    }
    
    func sendGameToClients(cards: [CardType]) {
        // send the cards as [CardType] to each client
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cards) {
            
            guard let mcSession = SessionManager.shared.session else {
                print("session is wonky")
                return
            }
            print("session is ok!")
            print("there are \(mcSession.connectedPeers.count) connected peers")
            if mcSession.connectedPeers.count > 0 {
                print ("someone to play with!")
                //let data = Data("message from host".utf8)
                do {
                    try mcSession.send(encoded, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    print("message not sent properly from host")
                }
            }
        }
    }
    
    func pickPlayer() {
        let myTurn = SessionManager.shared.setupPlayers()
        if myTurn {
            makeActivePlayer()
        } else {
            makeInactivePlayer()
        }
    }
    


    
 
    

}
