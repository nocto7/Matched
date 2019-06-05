//
//  GameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import MultipeerConnectivity
import SpriteKit

class ClientGameScene: BaseGameScene {
  
    func setCards(cardTypes: [CardType]) {
        print("client has recieved the card set: \(cardTypes)")
        print("there are \(cardTypes.count) cards in the set")
        let grid = CardGridInfo(items: cardTypes.count, windowSize: self.size)
        print("use grid \(grid)")
        setUpCards(cardTypes, grid)
        isUserInteractionEnabled = false
    }
    
    func myTurn() {
        print("I can tap stuffs")
        isUserInteractionEnabled = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touched client game")
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
                    SessionManager.shared.broadcastMessage(message: "endturn")
                    self?.isUserInteractionEnabled = false
                }
            }
        }
    }
    
    func isGameFinished() {
        print("number of cards left: \(cards.count)")
        if cards.count == 0 {
//            level += 1
//            let items = min((level + 1) * 4, 32) // 4*4*2 card variations at the mo, limits the game
//            level(items: items )
        }
    }
}
