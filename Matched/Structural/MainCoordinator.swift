//
//  MainCoordinator.swift
//  Matched
//
//  Created by kirsty darbyshire on 23/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    
    init(navigationController: MyNavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = GameViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: false)
    }
    
    func connectToGame() {
        let vc = ConnectionViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func hostMultiplayerGame() {
        let vc = MultiplayerGameViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
    
    func multiplayerGameClient() {
        let vc = ClientViewController.instantiate()
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
