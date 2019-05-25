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
        backgroundColor = UIColor(cgColor: ColourManager.shared.palest) //UIColor(named: "MyPurplePalest")!
        
        // origin is in the centre of the screen
        let screenWidth = self.size.width //view.bounds.size.width
        let screenHeight = self.size.height
        
        print("screen is \(screenWidth) x \(screenHeight)")
        
        let screenRatio = screenWidth / screenHeight
        print("screen ratio is \(screenRatio)")
        
        let bestRows = sqrt(CGFloat(items) / screenRatio)
        let bestCols = bestRows * screenRatio
        print("best num of rows, cols is \(bestRows), \(bestCols)")
        
        // err on the side of making cards taller than they are wide
        // i.e use more columns
        let numCols = Int(ceil(bestCols))
        var numRows = items / numCols
        if (numRows * numCols < items) {
            numRows += 1
        }
        print("using rows and cols \(numRows), \(numCols)")
        
        let cardNumber = numCols * numRows
        
        if (cardNumber%2 == 1) {
            // odd number
            print("odd number of card spaces, need to miss one out")
        }
        
        let rowsFloat = CGFloat(numRows)
        let colsFloat = CGFloat(numCols)
        
        let cardWidth = screenWidth /  (colsFloat + (colsFloat + 1) / 5.0)
        let cardHeight = screenHeight / (rowsFloat + (rowsFloat + 1) / 5.0)
        print("card size is \(cardWidth) x \(cardHeight)")
        
        let colSpacing = cardWidth / 5.0
        let rowSpacing = cardHeight / 5.0
        
        let symbols = getSymbols(number: numRows * numCols / 2)
        var allSymbols = symbols + symbols
        print (allSymbols)
        allSymbols.shuffle()
        
        let cardBack = drawCardBack(size: CGSize(width: cardWidth, height: cardHeight))
        
        for r in 0..<numRows {
            for c in 0..<numCols {
                let x = (cardWidth + colSpacing) * CGFloat(c) + colSpacing
                let y = (cardHeight + rowSpacing) * CGFloat(r) + rowSpacing
                let card = CardNode(color: .red, size: CGSize(width: cardWidth, height: cardHeight))
                if let symbol = allSymbols.popLast() {
                    card.setup(text: symbol, back: cardBack)
                    print("\(r), \(c) : \(x),\(y)")
                    let move = SKAction.move(to: CGPoint(x: x + cardWidth / 2, y: y + cardHeight / 2), duration: 1.0)
                    //card.position = CGPoint(x: x + cardWidth / 2, y: y + cardHeight / 2)
                    card.position = CGPoint(x: 0, y: 0)
                    card.run(move)
                    cards.append(card)
                    addChild(card)
                }
            }
        }
    }
    
    func getSymbols(number: Int) -> [String] {
        let emojis = "❤️😀🐶⭐️🍏🏳️‍🌈📕📱🏖⛵️🚛🧩🏄🏾‍♂️🤸🏼‍♀️💙💚💛🧡💝😂🥰😜😎🥶🤗☠️👻🎃😺😻👍💋👧🏾👀👵🏼👳🏾‍♀️🧕🏽👮🏽‍♂️👩🏻‍⚕️👩🏽‍🎤👩🏻‍💻👩🏼‍🔬👰🏿🦹🏿‍♀️🧟‍♀️🧟‍♂️🤱🏽💇🏽‍♀️💆🏿‍♂️👯‍♂️🚶🏼‍♀️💃🏾🦊🐷🐸🐰🐹🙊🐔🐣"
        var possSymbols = [String]()
       
        for char in emojis {
            possSymbols.append(String(char))
        }
         print("there are \(possSymbols.count) possible emojis")
        possSymbols.shuffle()
        var symbols = [String]()
        for _ in 0..<number {
            symbols.append(possSymbols.popLast()!)
        }
        return symbols
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        if let tappedCard = tappedNodes.first as? CardNode {
            print("touched game: \(tappedCard.text)")
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
    
    
    func drawCardBack(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { (ctx) in
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let cornerRadius = size.width / 10
            let roundedRect = UIBezierPath(roundedRect: rectangle, cornerRadius: cornerRadius)
            ctx.cgContext.setFillColor(ColourManager.shared.regular)
            ctx.cgContext.setStrokeColor(ColourManager.shared.pale)
            ctx.cgContext.setLineWidth(5)
            
            //ctx.cgContext.addRect(rectangle)
            ctx.cgContext.addPath(roundedRect.cgPath)
            ctx.cgContext.drawPath(using: .fillStroke)
            
        }
        return img
    }
    
    func isGameFinished() {
        print("number of cards left: \(cards.count)")
        if cards.count == 0 {
            level += 1
            var items = min((level + 1) * 4, 120) // 60 emojis limits the game
            level(items: items )
        }
    }
}
