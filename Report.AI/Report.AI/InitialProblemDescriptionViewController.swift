//
//  ViewController.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/12/24.
//

import UIKit

class InitialProblemDescriptionViewController: UIViewController {

    @IBOutlet weak var InitialComplaintImageView: UIImageView!
    @IBOutlet weak var PhotoSelectorButton: UIButton!
    
    
    @IBOutlet weak var problemStatementLabel: UILabel!
    
    @IBOutlet weak var analyzeButton: UIButton!
    
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //disable the button
        analyzeButton.isEnabled = false //disable the upload button initialy, may want to gray it out too
        continueButton.isHidden = true
    }
    
    /// Allow the user to choose or take a photo from their camera
    @IBAction func photoSelectionOrCapture(_ sender: UIButton) {
        presentImagePicker()
    
    }
    
    @IBAction func AnalyzeImage(_ sender: Any) {
        if let addedImage = InitialComplaintImageView.image {
            Task {
               await GeminiManager.shared.generateProblemAndDescriptionFromImage(input: addedImage)
                }
            }
        }
    
    
}

extension InitialProblemDescriptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // or .camera
        imagePickerController.allowsEditing = false // Allow editing if needed
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            // Handle the selected image
            // For example, assign it to an image view:
            // imageView.image = selectedImage
            InitialComplaintImageView.image = selectedImage
            analyzeButton.isEnabled = true // enable the button again
            
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
