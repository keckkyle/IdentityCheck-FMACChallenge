//
//  HomeViewController.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/1/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit
import AVFoundation

class HomeViewController: UIViewController {
    
    private var cameraAccess = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //hide navigation bar from home screen
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthorization()
    }
    
    //Function to check authorization of camera use or request access
    private func requestAuthorization() {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) == AVAuthorizationStatus.authorized {
            self.cameraAccess = true
        } else {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) {
                granted in
                if granted {
                    self.cameraAccess = true
                } else {
                    self.cameraAccess = false
                }
            }
        }
    }
    
    //handle user touch for select photo button
    @IBAction func goToNextView(_ sender: Any) {
        //Check if authorized to access camera and that there is an available camera before navigating to the camera.
        if cameraAccess && UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            goToCamera()
        } else {
            goToSelect()
        }
    }
    
    //navigate to camera view
    private func goToCamera(){
        self.performSegue(withIdentifier: "takePhotos", sender: nil)
    }
    
    //navigate to select photo view
    private func goToSelect(){
        self.performSegue(withIdentifier: "selectPhotos", sender: nil)
    }
}
