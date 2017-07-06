//
//  ViewController.swift
//  MoviePracticeApp
//
//  Created by Lynn Trickey on 7/3/17.
//  Copyright © 2017 Lynn Trickey. All rights reserved.
//

import UIKit
import MobileCoreServices

class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var shotNameLabel: UILabel!
    @IBOutlet weak var shotDescLabel: UILabel!

    @IBOutlet weak var shotImageView: UIImageView!
    
    // set optional shot variable 
    var shot: Shot?
    
    //connecting touch up inside from button to record video.
    @IBAction func record(_ sender: UIButton) {
        // added _ = to say we're not capturing result.  
        _ = startCameraFromViewController(self, withDelegate: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up views with existing Shot.
        if let shot = shot {
            navigationItem.title = shot.name
            shotNameLabel.text = shot.name
            shotImageView.image = shot.photo
            shotDescLabel.text = shot.description
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func startCameraFromViewController(_ viewController: UIViewController, withDelegate delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) -> Bool {
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            return false
        }
        
        let cameraController = UIImagePickerController()
        cameraController.sourceType = .camera
        cameraController.mediaTypes = [kUTTypeMovie as NSString as String]
        cameraController.allowsEditing = false
        cameraController.delegate = delegate
        
        present(cameraController, animated: true, completion: nil)
        return true
    }
    
    func video(_ videoPath: NSString, didFinishSavingWithError error: NSError?, contextInfo info: AnyObject) {
        var title = "Success"
        var message = "Video was saved"
        if let _ = error {
            title = "Error"
            message = "Video failed to save"
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}

// MARK: - UIImagePickerControllerDelegate

extension ViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        dismiss(animated: true, completion: nil)
        
        // Handle a movie capture
        if mediaType == kUTTypeMovie {
          // took away GUARD statement here b/c of errors
            let path = (info[UIImagePickerControllerMediaURL] as! URL).path
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(path) {
                UISaveVideoAtPathToSavedPhotosAlbum(path, self, #selector(ViewController.video(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
}

// MARK: - UINavigationControllerDelegate

extension ViewController: UINavigationControllerDelegate {
}


