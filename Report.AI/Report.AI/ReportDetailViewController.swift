//
//  ReportDetailViewController.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/6/24.
//

import UIKit

class ReportDetailViewController: UIViewController {
    var problemName: String?
    var problemDescription: String?
    var initialImage: UIImage?
    
    @IBOutlet weak var InitialimageImageView: UIImageView!
    
    @IBOutlet weak var AddressTextFeild: UITextField!
    
    @IBOutlet weak var ProblemDescription: UITextView!
    
    @IBOutlet weak var ProblemNameLabel: UILabel!
    
    
    @IBOutlet weak var AddAnImageButton: UIButton!
    
    @IBOutlet weak var ImagesStackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        ProblemNameLabel.text = problemName
        
        ProblemDescription.text = problemDescription
        
        addImageToStackView(with: initialImage!)
        
        self.hideKeyboardWhenTappedAround()
        
    }
    
    @IBAction func addMoreImages(_ sender: Any) {
        presentImagePicker()
        
    }
    
    func setIamgeViewProperties() {
        
    }
    
    @IBAction func uploadUserComplaint(_ sender: Any) {
    }
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}



extension ReportDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func presentImagePicker() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary // or .camera
        imagePickerController.allowsEditing = true // Allow editing if needed
        
        
        present(imagePickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let editedImage = info[.editedImage] as? UIImage
        let originalImage = info[.originalImage] as? UIImage
        
        //can edit the image...
        if let selectedImage = editedImage ?? originalImage {
            addImageToStackView(with: selectedImage)
        }
        

        picker.dismiss(animated: true, completion: nil)
    }
    
    
    // This action is triggered when the user selects a date
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        let selectedDate = sender.date
        print(selectedDate)// Save the date in your preferred way
        //will need to print the date here well
        
    }
    func addImageToStackView(with image: UIImage) {
        
        let newImageView = UIImageView(image: image)
        
        newImageView.translatesAutoresizingMaskIntoConstraints = false
        newImageView.contentMode = .scaleAspectFit
        
        
        //newImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
       // newImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        newImageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        newImageView.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        
        newImageView.isUserInteractionEnabled = true // Enable user interaction
        
        // Add a tap gesture recognizer to the image view
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(_:)))
        
        newImageView.addGestureRecognizer(tapGesture)
        
        // Add the image view to the stack view
        ImagesStackView.addArrangedSubview(newImageView)
        
        print("Stack View Size now: \(ImagesStackView.frame.size)")
    }
    
    @objc func imageTapped(_ gesture: UITapGestureRecognizer) {
        if let imageView = gesture.view as? UIImageView {
            showConfirmationDialog(for: imageView)
        }
    }
    
    func showConfirmationDialog(for imageView: UIImageView) {
        let alert = UIAlertController(title: "Remove Image", message: "Are you sure you want to remove this image?", preferredStyle: .alert)
        
        // Add "Remove" action
        alert.addAction(UIAlertAction(title: "Remove", style: .destructive, handler: { _ in
            self.ImagesStackView.removeArrangedSubview(imageView)
            imageView.removeFromSuperview()
        }))
        
        // Add "Cancel" action
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        // Present the alert
        present(alert, animated: true, completion: nil)
    }
    
}
