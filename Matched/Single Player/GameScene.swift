//
//  GameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import SpriteKit

// this needs to be a BaseGameScene too

class GameScene: BaseGameScene {
    var level = 1
    
    override func didMove(to view: SKView) {
        let items = 4
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
        
        cardTypes.shuffle()
        
        setUpCards(cardTypes, grid)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
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
                tappedCard.revealCard(broadcast: false) {}
            }
            else if cardSelected!.name == tappedCard.name {
                // a match! remove both cards
                let otherCard = cardSelected
                cardSelected = nil
                tappedCard.revealCard(broadcast: false) {
                    [weak self] in
                    // remove the nodes
                    otherCard?.removeCard(broadcast: false)
                    tappedCard.removeCard(broadcast: false)
                    
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
                tappedCard.revealCard(broadcast: false) {
                    tappedCard.concealCard(broadcast: false)
                    otherCard?.concealCard(broadcast: false)
                }
            }
        }
    }
    
    func isGameFinished() {
        print("number of cards left: \(cards.count)")
        if cards.count == 0 {
            level += 1
            let items = min((level + 1) * 4, 64) // 4*4*4 card variations at the mo, limits the game
            level(items: items )
        }
    }
}
