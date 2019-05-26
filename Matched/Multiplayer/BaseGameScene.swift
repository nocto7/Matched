//
//  BaseGameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 26/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit
import GameplayKit


class BaseGameScene: SKScene {
    var cards = [CardNode]()
    var cardSelected: CardNode?
    
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
    func revealCard(number: String) {
        guard let num = Int(number) else { return }
        for card in cards {
            if card.info.sequenceNumber == num {
                card.revealCard(broadcast: false) {
                    // do nowt
                }
            }
        }
    }
    
    // used when other clients conceal a card
    func concealCard(number: String) {
        guard let num = Int(number) else { return }
        for card in cards {
            if card.info.sequenceNumber == num {
                card.concealCard(broadcast: false)
            }
        }
    }
    
    // used when other clients show a card
    func removeCard(number: String) {
        guard let num = Int(number) else { return }
        for card in cards {
            if card.info.sequenceNumber == num {
                card.removeCard(broadcast: false) 
            }
        }
    }

}
