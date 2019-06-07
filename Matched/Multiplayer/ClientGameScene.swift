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
    var controller: ClientViewController!
    
    override func didMove(to view: SKView) {
        playerState = PlayerState(mode: .multi, status: .unknown, role: .client)
    }
    

    func setCards(cardTypes: [CardType]) {
        print("client has recieved the card set: \(cardTypes)")
        print("there are \(cardTypes.count) cards in the set")
        let grid = CardGridInfo(items: cardTypes.count, windowSize: self.size)
        print("use grid \(grid)")
        setUpCards(cardTypes, grid)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if playerState.status == .waiting {
            controller.turnLabel.text = "Other Player's Turn!"
            isUserInteractionEnabled = false
        } else if playerState.status == .current {
            controller.turnLabel.text = ""
            isUserInteractionEnabled = true
        } else {
            controller.turnLabel.text = "Waiting"
            isUserInteractionEnabled = false
        }
    }
    
}
