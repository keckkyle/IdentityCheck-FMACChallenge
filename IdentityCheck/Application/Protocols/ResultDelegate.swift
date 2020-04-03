//
//  ResultDelegate.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/1/20.
//  Copyright © 2020 revature. All rights reserved.
//

import Foundation

//Set up protocol that delegate will follow
protocol ResultDelegate {
    func resultDidCalculate(result: NSNumber)
    func resultError(error: String)
}
