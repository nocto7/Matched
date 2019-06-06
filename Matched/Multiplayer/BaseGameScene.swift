//
//  BaseGameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 26/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit

class BaseGameScene: SKScene {
    var cards = [CardNode]()
    var cardSelected: CardNode?
    var playerState: PlayerState!
    
    func setUpCards(_ cardTypes: [CardType], _ grid: CardGridInfo) {
        var deck = [CardInfo]()
        for cardType in cardTypes {
            let cardInfo = CardInfo(name: cardType.name, face: CardGenerator.shared.getNewFaceImage(type: cardType, size: grid.cardSize), sequenceNumber: cardType.sequenceNumber)
            deck.append(cardInfo)
        }
        
        let cardBack = CardGenerator.shared.drawCardBack(size: grid.cardSize)
        
        for r in (0 ..< grid.rows).reversed() { // backwards so missing cards are at bottom of screen
            for c in 0 ..< grid.cols {
                let card = CardNode(color: .red, size: grid.cardSize)
                if let cardInfo = deck.popLast() {
                    card.setup(info: cardInfo, back: cardBack)
                    let move = SKAction.move(to: grid.position(row: r, col: c), duration: 1.5)
                    card.position = CGPoint(x: -100, y: -100)
                    card.run(move)
                    cards.append(card)
                    addChild(card)
                }
            }
        }
    }
    
    // used when other clients show a card
    func revealCard(number: Int) {
        for card in cards {
            if card.info.sequenceNumber == number {
                card.revealCard(broadcast: false) {
                    // do nowt
                }
            }
        }
    }
    
    // used when other clients conceal a card
    func concealCard(number: Int) {
        for card in cards {
            if card.info.sequenceNumber == number {
                card.concealCard(broadcast: false)
            }
        }
    }
    
    // used when other clients show a card
    func removeCard(number: Int) {
        for card in cards {
            if card.info.sequenceNumber == number {
                card.removeCard(broadcast: false) 
            }
        }
    }
    
    // make player active or inactive, leave everything but the status alone
    func makeActivePlayer()  {
        playerState = PlayerState(mode: playerState.mode, status: .current, role: playerState.role)
    }
    
    func makeInactivePlayer()  {
        playerState = PlayerState(mode: playerState.mode, status: .waiting, role: playerState.role)
    }
    
    func getBroadcastStatus() -> Bool {
        switch playerState.mode {
        case .multi:
            return true
        case .single:
            return false
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let isBroadcasting = getBroadcastStatus()
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
                tappedCard.revealCard(broadcast: isBroadcasting) {}
            }
            else if cardSelected!.name == tappedCard.name {
                // a match! remove both cards
                let otherCard = cardSelected
                cardSelected = nil
                tappedCard.revealCard(broadcast: isBroadcasting) {
                    [weak self] in
                    // remove the nodes
                    otherCard?.removeCard(broadcast: isBroadcasting)
                    tappedCard.removeCard(broadcast: isBroadcasting)
                    
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
                tappedCard.revealCard(broadcast: isBroadcasting) {
                    [weak self] in
                    tappedCard.concealCard(broadcast: isBroadcasting)
                    otherCard?.concealCard(broadcast: isBroadcasting)
                    // move to next player, set my status as required
                   self?.nextPlayer()
                }
            }
        }
    }
    
    func nextPlayer() {
        // single player
        if playerState.mode == .single { return }
        
        // client
        if playerState.role == .client {
            SessionManager.shared.endTurn()
            makeInactivePlayer()
            return
        }
        
        // server
        playerState = SessionManager.shared.nextPlayer(myState: playerState)
    }
    
    func isGameFinished() {
        print("game has this number of cards left: \(cards.count)")
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerState.status == .current {
            isUserInteractionEnabled = true
        } else {
            isUserInteractionEnabled = false
        }
    }
    

}
