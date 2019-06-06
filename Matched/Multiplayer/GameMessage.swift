//
//  GameMessage.swift
//  Matched
//
//  Created by kirsty darbyshire on 06/06/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation

// following https://dmtopolog.com/serialisation-of-enum-with-associated-type/

enum GameMessage: Codable {
    case setup(cards: [CardType])
    case reveal(card: Int)
    case conceal(card: Int)
    case remove(card: Int)
    case endturn
    
    enum CodingKeys: String, CodingKey {
        case setup, reveal, conceal, remove, endturn
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        switch self {
        case .setup(let cards):
            try container.encode(cards, forKey: .setup)
        case .reveal(let card):
            try container.encode(card, forKey: .reveal)
        case .conceal(let card):
            try container.encode(card, forKey: .conceal)
        case .remove(let card):
            try container.encode(card, forKey: .remove)
        case .endturn:
            try container.encode(true, forKey: .endturn)
        }
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        if let value = try? values.decode(Int.self, forKey: .reveal) {
            self = .reveal(card: value)
            return
        } else if let value = try? values.decode(Int.self, forKey: .conceal) {
            self = .conceal(card: value)
            return
        } else if let value = try? values.decode(Int.self, forKey: .remove) {
            self = .remove(card: value)
            return
        } else if let _ = try? values.decode(Bool.self, forKey: .endturn) {
            self = .endturn
            return
        } else if let value = try? values.decode([CardType].self, forKey: .setup) {
            self = .setup(cards: value)
            return
        }else {
            print("trying to decode a message that I can't understand; probably not important!")
            throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "We got some data we couldn't understand in the message"))
        }
    }
    
}
