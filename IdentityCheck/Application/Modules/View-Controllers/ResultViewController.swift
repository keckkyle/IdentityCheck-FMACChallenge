//
//  ResultViewController.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/1/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    @IBOutlet weak var matchLabel: UILabel!
    @IBOutlet weak var matchSublabel: UILabel!
    
    @IBOutlet weak var sourceView: UIImageView!
    @IBOutlet weak var targetView: UIImageView!
    
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    
    var sourceData: Data!
    var targetData: Data!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //set display photos
        sourceView.image = UIImage(data: sourceData)
        targetView.image = UIImage(data: targetData)
        //set delegate to receive data from API call
        RekognitionService.resultDelegate = self
    }

}


//MARK: This extension contains the functionality required for the result delegate
extension ResultViewController: ResultDelegate {
    //update result view with result data
    func resultDidCalculate(result: NSNumber) {
        let intResult = result.intValue
        matchLabel.text = "\(intResult)%"
        removeLoadingView()
    }
    
    //update result view if the API cannot process the photos
    func resultError(error: String) {
        matchLabel.text = error
        matchLabel.font = UIFont.systemFont(ofSize: 22)
        matchSublabel.text = "Please try again."
        removeLoadingView()
    }
    
    private func removeLoadingView() {
        loadingView.isHidden = true
        loadingIndicator.stopAnimating()
    }
}
