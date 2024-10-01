//
//  ViewController.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/12/24.
//

import UIKit
import SwiftUI
//
//  ViewController.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/12/24.
//

import UIKit
import SwiftUI


class InitialProblemDescriptionViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var InitialComplaintImageView: UIImageView!
    @IBOutlet weak var PhotoSelectorButton: UIButton!
    @IBOutlet weak var problemStatementLabel: UILabel!
    @IBOutlet weak var newAnalysisInstructionLabel: UILabel!
    @IBOutlet weak var AnalysisLoadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var analyzeButton: UIButton! {
        didSet {
            if !analyzeButton.isEnabled {
                showAnalyzeHelpText()
            }
        }
    }
    @IBOutlet weak var continueButton: UIButton!
    
    @IBOutlet weak var CameraButton: UIButton!
    // MARK: - Variables
    var imagePickerController: UIImagePickerController?
    var imageSourceType: UIImagePickerController.SourceType = .camera
    var problemName: String = ""
    var problemDescription: String = ""
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        self.hideKeyboardWhenTappedAround()
    }
    
    // MARK: - Setup UI
    func setupUI() {
        analyzeButton.isEnabled = false
        continueButton.isHidden = true
        newAnalysisInstructionLabel.isHidden = true
        addBorderToImageView()
    }
    
    // MARK: - Actions
    @IBAction func photoSelectionOrCapture(_ sender: UIButton) {
        initializeImagePickerController(with: .photoLibrary)
    }
    
    @IBAction func takePhotoFromCamera(_ sender: Any) {
        initializeImagePickerController(with: .camera)
    }
    
    
    @IBAction func AnalyzeImage(_ sender: Any) {
        guard let addedImage = InitialComplaintImageView.image else { return }
        
        AnalysisLoadingIndicator.startAnimating()
        
        Task {
            let result = await GeminiManager.shared.generateProblemAndDescriptionFromImage(input: addedImage)
            problemName = result.0.replacingOccurrences(of: "\'", with: "")
            problemDescription = result.1.replacingOccurrences(of: "\'", with: "\'")
            
            updateUIAfterAnalysis()
        }
    }
    
    @IBAction func showReportDetailSwiftUIView(_ sender: Any) {
        guard let image = InitialComplaintImageView.image else { return }
        let hostingVC = UIHostingController(rootView: InitalScreenView(initialImage: image, problemDescription: problemDescription))
        navigationController?.pushViewController(hostingVC, animated: true)
    }
    
    // MARK: - Helper Functions
    func addBorderToImageView() {
        InitialComplaintImageView.layer.borderColor = UIColor.black.cgColor
        InitialComplaintImageView.layer.borderWidth = 5.0
    }
    
    func showAnalyzeHelpText() {
        newAnalysisInstructionLabel.isHidden = false
    }
    
    func hideAnalyzeHelpText() {
        newAnalysisInstructionLabel.isHidden = true
    }
    
    func updateUIAfterAnalysis() {
        problemStatementLabel.text = "Problem: \(problemName)"
        continueButton.isHidden = false
        analyzeButton.isEnabled = false
        AnalysisLoadingIndicator.stopAnimating()
        newAnalysisInstructionLabel.isHidden = false
    }
    
    // Image Picker Configuration
    func initializeImagePickerController(with sourceType: UIImagePickerController.SourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.delegate = self
        imagePickerController!.sourceType = sourceType
        imagePickerController!.allowsEditing = true
        
        present(imagePickerController ?? UIImagePickerController(), animated: true, completion: nil)
    }
}

// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension InitialProblemDescriptionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
   
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        let editedImage = info[.editedImage] as? UIImage
        let originalImage = info[.originalImage] as? UIImage
        
        if let selectedImage = editedImage ?? originalImage {
            InitialComplaintImageView.image = selectedImage
            analyzeButton.isEnabled = true
            hideAnalyzeHelpText()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
