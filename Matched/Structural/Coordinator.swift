//
//  Coordinator.swift
//  Matched
//
//  Created by kirsty darbyshire on 23/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
