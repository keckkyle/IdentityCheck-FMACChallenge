//
//  SkipViewSegue.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/1/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit

//Segue to remove a veiw so back button skips to desired view
class SkipViewSegue: UIStoryboardSegue {
    override func perform() {
        //check for and set navigation controller
        if let navigationController = source.navigationController as UINavigationController? {
            //get controllers stack
            var controllers = navigationController.viewControllers
            //remove last controller from stack
            controllers.removeLast()
            //add destination controller to stack
            controllers.append(destination)
            navigationController.setViewControllers(controllers, animated: true)
        }
    }
}
