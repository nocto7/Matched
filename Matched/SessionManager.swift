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
    
    func setup(session: MCSession) {
        self.session = session
    }
}
