//
//  RekognitionService.swift
//  IdentityCheck
//
//  Created by Kyle Keck on 4/1/20.
//  Copyright © 2020 revature. All rights reserved.
//

import Foundation
import AWSRekognition
import os.log

class RekognitionService {
    
    private static var rekognitionObject: AWSRekognition?
    
    static var resultDelegate: ResultDelegate!
    
    static func compareFaces(sourceData: Data, targetData: Data) {
        
        rekognitionObject = AWSRekognition.default()
        let source = AWSRekognitionImage()
        source?.bytes = sourceData
        let target = AWSRekognitionImage()
        target?.bytes = targetData
        
        let compareRequest = AWSRekognitionCompareFacesRequest()
        compareRequest?.sourceImage = source
        compareRequest?.targetImage = target
        
        rekognitionObject?.compareFaces(compareRequest!) { (response, error) in
            if error != nil {
                os_log("Error: Request could not be processed")
                DispatchQueue.main.sync {
                    resultDelegate.resultError(error: "Could not process selected photos.")
                }
                return
            }
            
            if response != nil {                
                guard response!.faceMatches!.count > 0 else {
                    os_log("Error: No match found")
                    DispatchQueue.main.sync {
                        resultDelegate.resultError(error: "No match found.")
                    }
                    return
                }
                
                DispatchQueue.main.sync {
                    resultDelegate.resultDidCalculate(result: response!.faceMatches![0].similarity!)
                }
            }
            
            
            
        }
        
    }
    
}
