//
//  GameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit
import GameplayKit


class MultiplayerGameScene: BaseGameScene {

    var level = 3 // start multiplayer game at higher level
    
    override func didMove(to view: SKView) {
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
            isUserInteractionEnabled = true
        }
    }
    

    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         print("touched server game")
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        if let tappedCard = tappedNodes.first as? CardNode {
            print("touched game: \(String(describing: tappedCard.info))")
            if (tappedCard == cardSelected) {
                // tapping on same card twice does nothing
                return
            }
            if cardSelected == nil {
                cardSelected = tappedCard
                tappedCard.revealCard(broadcast: true) {}
            }
            else if cardSelected!.name == tappedCard.name {
                // a match! remove both cards
                let otherCard = cardSelected
                cardSelected = nil
                tappedCard.revealCard(broadcast: true) {
                    [weak self] in
                    // remove the nodes
                    otherCard?.removeCard(broadcast: true)
                    tappedCard.removeCard(broadcast: true)
                    
                    // then remove from the cards array
                    for (i, card) in ((self?.cards.enumerated().reversed())!) {
                        if otherCard == card {
                            self?.cards.remove(at: i)
                        }
                        if tappedCard == card {
                            self?.cards.remove(at: i)
                        }
                    }
                    self?.isGameFinished()
                }
                
            } else {
                // not a match, turn both cards face down again
                let otherCard = cardSelected
                cardSelected = nil
                tappedCard.revealCard(broadcast: true) {
                    [weak self] in
                    tappedCard.concealCard(broadcast: true)
                    otherCard?.concealCard(broadcast: true)
                    // move to next player, if it's my turn let me tap
                    self?.isUserInteractionEnabled = SessionManager.shared.newPlayer()
                    
                }
            }
        }
    }
    
    func isGameFinished() {
        print("number of cards left: \(cards.count)")
        if cards.count == 0 {
            level += 1
            let items = min((level + 1) * 4, 32) // 4*4*2 card variations at the mo, limits the game
            level(items: items )
        }
    }
}
