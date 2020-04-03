//
//  ViewController.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 3/31/20.
//  Copyright © 2020 revature. All rights reserved.
//

import UIKit
import AVFoundation
import os.log

class CameraViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIView!
    @IBOutlet weak var selectImageButton: UIButton!
    @IBOutlet weak var imagePreviewView: UIView!
    @IBOutlet weak var imagePreview: UIImageView!
    @IBOutlet weak var retakeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!
    
    private var session = AVCaptureSession()
    private var photoOutput: AVCapturePhotoOutput?
    private var videoPreview: AVCaptureVideoPreviewLayer?
    
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    
    private var image: UIImage?
    
    private var currentImageData:Data?
    private var sourceImageData:Data?
    private var targetImageData:Data?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //show navigation bar
        self.navigationController?.isNavigationBarHidden = false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set title text in navigation bar
        self.title = "Take a photo of yourself"
        
        //add red circle border to capture button
        captureButton.layer.borderWidth = 3
        captureButton.layer.borderColor = UIColor.red.cgColor
        
        //run set up camera function
        setupCamera()
    }
    
    //handle user touch of capture photo button
    @IBAction func capturePhoto(_ sender: Any) {
        let photoSettings = AVCapturePhotoSettings()
        photoOutput?.capturePhoto(with: photoSettings, delegate: self)
    }
    
    //handle user touch to rotate camera
    @IBAction func rotateCamera(_ sender: Any) {
        switchCamera()
    }

    //handle user touch to open the device photo library
    @IBAction func selectImage(_ sender: Any) {
        openPhotoLibrary()
    }
    
    //handle user touch to reset information to retake a photo
    @IBAction func retakePhoto(_ sender: Any) {
        startRunningSession()
        resetPreview()
    }
    
    //handle user touch to select the current photo
    @IBAction func submitPhoto(_ sender: Any) {
        if submitButton!.titleLabel!.text == "Use Photo"{
            setupCaptureID()
            startRunningSession()
            resetPreview()
            sourceImageData = currentImageData
        } else if submitButton!.titleLabel!.text == "Submit Photos" {
            targetImageData = currentImageData
            RekognitionService.compareFaces(sourceData: sourceImageData!, targetData: targetImageData!)
            performSegue(withIdentifier: "showResult", sender: nil)
        }
    }
    
    //function to switch between front and back cameras
    private func switchCamera() {
        // check current camera and set to the other camera
        if currentCamera == frontCamera {
            currentCamera = backCamera
        } else {
            currentCamera = frontCamera
        }
        //reset input using new current camera
        session.stopRunning()
        setupInput()
        startRunningSession()
    }
    
    //hide image view and remove image data
    private func resetPreview() {
        imagePreviewView.isHidden = true
        image = nil
    }
    
    //set default for ID selection
    private func setupCaptureID() {
        //set up back camera for default ID capture
        currentCamera = backCamera
        setupInput()
        //reset navigation title display
        self.title = "Take a photo of your ID"
        //set the text of the submit button on photo preview screen
        submitButton!.setTitle("Submit Photos", for: .normal)
    }
    
    //set up delegate to handle sselecting an image from the photo library on the device
    private func openPhotoLibrary(){
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let pickerController = UIImagePickerController()
            pickerController.delegate = self;
            pickerController.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(pickerController, animated: true, completion: nil)
        }
    }
    
    //set data to be sent to the result page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.title == "Result" {
            let vc = segue.destination as! ResultViewController
            vc.sourceData = sourceImageData
            vc.targetData = targetImageData
        }
    }

}


//MARK: Camera Functions: This extension contains all the functions to set up the camera display for the user.
extension CameraViewController {
    //setup the camera view
    private func setupCamera(){
        setupCaptureSession()
        setupDevice()
        setupInput()
        setupOutput()
        setupPreviewLayers()
        startRunningSession()
    }
    
    //Set AV capture session
    private func setupCaptureSession() {
        session.sessionPreset = AVCaptureSession.Preset.photo
    }

    //Set the availble camera devices and default initial camera to front
    private func setupDevice() {
        //find cameras avaiable on the device
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = discoverySession.devices
        
        //set devices to their proper variable
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
        
        //default to front camera
        currentCamera = frontCamera
    }
    
    //Set input for the current session
    private func setupInput() {
        //check for and remove existing input
        if let currentInput = session.inputs.first as? AVCaptureDeviceInput {
            session.removeInput(currentInput)
        }
        
        //set input from the current camera
        do {
            let deviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            session.addInput(deviceInput)
        } catch {
            os_log("Unable to set input from current camera")
        }
    }
    
    //set up output
    private func setupOutput() {
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey:AVVideoCodecType.jpeg])], completionHandler: nil)
        session.addOutput(photoOutput!)
    }
    
    //set up display of camera data
    private func setupPreviewLayers() {
        videoPreview = AVCaptureVideoPreviewLayer(session: session)
        videoPreview?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreview?.connection!.videoOrientation = AVCaptureVideoOrientation.portrait
        videoPreview?.frame = self.view.frame
        self.view.layer.insertSublayer(videoPreview!, at: 0)
    }
    
    //start running camera session
    private func startRunningSession() {
        session.startRunning()
    }
    
}


//MARK: AV Capture: This extension sets the view controller as the capture delegae. The code in this extension handles the image data when the user captures a photo.
extension CameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        if let imageData = photo.fileDataRepresentation() {
            currentImageData = imageData
            image = UIImage(data: imageData)
            imagePreview.image = image
            imagePreviewView.isHidden = false
            session.stopRunning()
        }
        
    }
    
}


//MARK: Image Picker: This extension sets the delegate for photo library picker. The functions here allow a user to select images from their photo library rather than captuer new images.
extension CameraViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        picker.dismiss(animated: true)
        let selectedImage = info[.originalImage] as! UIImage
        let data = selectedImage.jpegData(compressionQuality: 1)
        currentImageData = data
        imagePreview.image = selectedImage
        imagePreviewView.isHidden = false
        session.stopRunning()
        
    }
    
}

