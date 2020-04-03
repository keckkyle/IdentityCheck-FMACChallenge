//
//  Alert.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/2/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit

//reusable alert function for the app
func showAlert(title: String, message: String, view: UIViewController, acceptButton: String, completionHandler: ((UIAlertAction) -> Void)?){
    //set up alert
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    //add button to the alert with optional completion handler
    alert.addAction(UIAlertAction(title: acceptButton, style: .default, handler: completionHandler))
    //show alert on included view
    view.present(alert, animated: true)
    
}
