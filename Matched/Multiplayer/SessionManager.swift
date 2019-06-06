//
//  SessionManager.swift
//  Matched
//
//  Created by kirsty darbyshire on 25/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation
import MultipeerConnectivity

class SessionManager {
    static let shared = SessionManager()
    var session: MCSession!
    
    var currentPlayer: Int!
    var numPlayers: Int!
    var otherPlayers: [MCPeerID]! // hold onto them so they stay in order
    
    func setup(session: MCSession) {
        self.session = session
    }
    
    // returns value is whether this server is the current player
    func setupPlayers() -> Bool {
        otherPlayers = session.connectedPeers
        numPlayers = session.connectedPeers.count + 1
        currentPlayer = Int.random(in: 1...numPlayers)
        print("There are \(String(describing: numPlayers)) players, and \(String(describing: currentPlayer)) is the current player")
        return activatePlayer(currentPlayer)
    }
    
    // these functions need to manipulate states? or not be here?
    
    // move on to the next player, return correct status to this player
    func nextPlayer(myState: PlayerState?) -> PlayerState? {
        guard let state = myState else { return nil }
        switch state.role {
        case .some(.client):
            print("we're a client! we ought to tell the server we need the next player")
            return state
        case .some(.server):
             print("we're a server")
        case .none:
            print("we're not anything!")
            return state
        }
        if newPlayer() {
            return PlayerState(mode: state.mode, status: .current, role: state.role)
        } else {
            return PlayerState(mode: state.mode, status: .waiting, role: state.role)
        }
    }
    
    // returns value is whether this server is the current player
    func newPlayer() -> Bool {
        currentPlayer += 1
        if currentPlayer > numPlayers {
            currentPlayer = 1
        }
        return activatePlayer(currentPlayer)
        
    }
    
    // return value is whether this server is the current player
    func activatePlayer(_ playerNumber: Int) -> Bool {
        if currentPlayer == numPlayers {
            print("i'm the current player")
            return true
        } else {
            let player = otherPlayers[playerNumber - 1]
            print("\(player) is the current player")
            // send a message to tell them it's their turn
            sendMessage(message: "your turn", player: player)
            return false
        }
    }
    
    func sendMessage(message: String, player: MCPeerID) {
        let data = Data(message.utf8)
        do {
            try session.send(data, toPeers: [player], with: .reliable)
        } catch {
            print("message not sent properly from host")
        }
    }
    
    func broadcastMessage(message: String) {
        print("broadcasting the message: \(message) to \(session.connectedPeers.count) other players")
        let data = Data(message.utf8)
        do {
            try session.send(data, toPeers: session.connectedPeers, with: .reliable)
        } catch {
            print("message not sent properly from host")
        }
    }
    
    // used by the server to send the game setup to each client
    func shareGame(cards: [CardType]) {
        let message = GameMessage.setup(cards: cards)
        // send the cards as [CardType] to each client
        let encoder = JSONEncoder()
        if let encodedGame = try? encoder.encode(message) {
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
                    try mcSession.send(encodedGame, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    print("message not sent properly from host")
                }
            }
        }
        
        // old version
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
}
