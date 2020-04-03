//
//  HomeViewController.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/1/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hide navigation bar from home screen
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}
