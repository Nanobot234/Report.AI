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
    
    @IBOutlet weak var newAnalysisInstructionLabel: UILabel!
 
    @IBOutlet weak var analyzeButton: UIButton! {
        didSet {
            if !analyzeButton.isEnabled {
                showAnalyzeHelpText()
            }
        }
    }
    
    @IBOutlet weak var continueButton: UIButton!
    
    /// the name of the problem presented in the image. Like "overflowing trash" or "pothole"
     var problemName : String = "" //ASk AI about whether to cahnge thsi
    var problemDescription: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        analyzeButton.isEnabled = false
        continueButton.isHidden = true
        newAnalysisInstructionLabel.isHidden = true
        
        
        
        addBorderToImageView()
        self.hideKeyboardWhenTappedAround()
    }
    
    /// Allow the user to choose or take a photo from their camera
    @IBAction func photoSelectionOrCapture(_ sender: UIButton) {
        presentImagePicker()
    
        
    }
    
    @IBAction func AnalyzeImage(_ sender: Any) {
        if let addedImage = InitialComplaintImageView.image {
            Task {
              let result = await GeminiManager.shared.generateProblemAndDescriptionFromImage(input: addedImage)
                problemName = result.0
                problemDescription = result.1
                
                problemStatementLabel.text = "Problem: " + problemName// continue
                
                continueButton.isHidden = false
                analyzeButton.isEnabled = false
                }
            
            
            }
        }
    
    //more here
    func addBorderToImageView() {
        InitialComplaintImageView.layer.borderColor = UIColor.black.cgColor
        InitialComplaintImageView.layer.borderWidth = 5.0
    }
    
    func showAnalyzeHelpText() {
        newAnalysisInstructionLabel.isHidden = false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToReportDetail" {
            
            //
            if let destinationVC = segue.destination as? ReportDetailViewController {
                //pass the name and description to the second view controller
                destinationVC.problemName = problemName
                destinationVC.problemDescription = problemDescription
                destinationVC.initialImage = InitialComplaintImageView.image
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
