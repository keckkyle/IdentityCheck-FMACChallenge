//
//  SelectPhotosViewController.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/2/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit
import os.log

class SelectPhotosViewController: UIViewController {
    
    @IBOutlet weak var sourceImage: UIImageView!
    @IBOutlet weak var targetImage: UIImageView!
    
    private var buttonPressed = 0
    private var sourceData: Data?
    private var targetData: Data?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //show navigation bar
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    //handle user touch of select photos buttons
    @IBAction func selectPhoto(_ sender: Any) {
        let button = sender as! UIButton
        //set the button that user selected
        buttonPressed = button.tag
        openPhotoLibrary()
    }
    
    //Handle user touch of the submit button
    @IBAction func submitPhotos(_ sender: Any) {
        
        guard let source = sourceData, let target = targetData else {
            showAlert(title: "Photo not found", message: "Please select two photos to compare", view: self, acceptButton: "Select photos", completionHandler: nil)
            os_log("Photos not found")
            return
        }
        
        RekognitionService.compareFaces(sourceData: source, targetData: target)
        performSegue(withIdentifier: "displayResult", sender: nil)
    }
    
    //Open device photo library
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //set data to be sent to result page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ResultViewController
        vc.sourceData = sourceData
        vc.targetData = targetData
    }
    
}


//MARK: This extension provides the functionality to handle images selected by the user from the device library
extension SelectPhotosViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let selected = info[.originalImage] as! UIImage
        let data = selected.jpegData(compressionQuality: 1)
        //set the displayed image and image data based on selected button
        if buttonPressed == 1 {
            sourceImage.image = selected
            sourceData = data
        } else if buttonPressed == 2 {
            targetImage.image = selected
            targetData = data
        }
    }
}
