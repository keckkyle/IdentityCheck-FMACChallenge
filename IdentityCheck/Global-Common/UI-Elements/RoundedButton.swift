//
//  RoundedButton.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/2/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit

//creates rounded button used throughout app
class RoundedButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupButton()
    }
    
    func setupButton(){
        //set rounded corners
        layer.cornerRadius = 20
        //set button height
        heightAnchor.constraint(equalToConstant: 40).isActive = true
        //set button font
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
    }

}


