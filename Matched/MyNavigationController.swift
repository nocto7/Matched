//
//  MyNavigationController.swift
//  Matched
//
//  Created by kirsty darbyshire on 22/05/2019.
//  Copyright © 2019 nocto. All rights reserved.
//

import UIKit

class MyNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .allButUpsideDown
        //        if UIDevice.current.userInterfaceIdiom == .phone {
        //            return .allButUpsideDown
        //        } else {
        //            return .all
        //        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
