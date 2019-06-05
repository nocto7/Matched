//
//  PlayerState.swift
//  Matched
//
//  Created by kirsty darbyshire on 04/06/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation

struct PlayerState {
    let mode: PlayMode // single/multi
    let status: PlayerStatus // current/waiting
    let role: HostRole? // server/client (not set for single player)
}

enum PlayMode {
    case single
    case multi
}

enum PlayerStatus {
    case current
    case waiting
    case unknown
}

enum HostRole {
    case server
    case client
}


