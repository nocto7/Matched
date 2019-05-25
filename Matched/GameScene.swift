//
//  GameScene.swift
//  Matched
//
//  Created by kirsty darbyshire on 21/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var cards = [CardNode]()
    var cardSelected: CardNode?
    var level = 1
    
    override func didMove(to view: SKView) {
        let items = 4
        level(items: items)
    }
    
    func level(items: Int) {
        
        ColourManager.shared.changeColour()
        backgroundColor = UIColor(cgColor: ColourManager.shared.palest)
        
        let grid = CardGridInfo(items: items, windowSize: self.size)
        
        let cardTypes = CardGenerator.shared.getNewCardNames(number: items / 2)
        print(cardTypes)
        
        var cardInfos = [CardInfo]()
        for cardType in cardTypes {
            let cardInfo = CardInfo(name: cardType.name, face: CardGenerator.shared.getNewFaceImage(type: cardType, size: grid.cardSize))
            cardInfos.append(cardInfo)
        }
        var deck = cardInfos + cardInfos // duplicate each card
        deck.shuffle()
        
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
                tappedCard.revealCard() {}
            }
            else if cardSelected!.name == tappedCard.name {
                // a match! remove both cards
                let otherCard = cardSelected
                cardSelected = nil
                tappedCard.revealCard() {
                    [weak self] in
                    // remove the nodes
                    otherCard?.removeCard()
                    tappedCard.removeCard()
                    
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
                tappedCard.revealCard() {
                    tappedCard.concealCard()
                    otherCard?.concealCard()
                }
            }
        }
    }
    
    func isGameFinished() {
        print("number of cards left: \(cards.count)")
        if cards.count == 0 {
            level += 1
            let items = min((level + 1) * 4, 24) // 4*3*2 card variations at the mo, limits the game
            level(items: items )
        }
    }
}
