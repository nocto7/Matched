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
        
        makeInactivePlayer()
        
        // now tell the clients about the cards too
        //sendGameToClients(cards: cardTypes)
        SessionManager.shared.shareGame(cards: cardTypes)
        
        setUpCards(cardTypes, grid)
        pickPlayer()
        
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
