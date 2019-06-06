//
//  MyNavigationController.swift
//  Matched
//
//  Created by kirsty darbyshire on 22/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {
    weak var coordinator: MainCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
    }
}
