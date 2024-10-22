//
//  ViewController.swift
//  Report.AI
//
//  Created by Nana Bonsu on 8/12/24.

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
    
    override func viewDidLayoutSubviews() {
           super.viewDidLayoutSubviews()
           updateImageViewSize()
           updateButtonLayout()
       }
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        addBorderToImageView()
    }
    private func updateImageViewSize() {
            let desiredHeight = view.bounds.height * 0.45
            InitialComplaintImageView.frame = CGRect(x: 20,
                                                     y: view.safeAreaInsets.top + 10,
                                                     width: view.bounds.width - 40,
                                                     height: desiredHeight)
        }
    
    // MARK: - Setup UI
    private func setupUI() {
            title = "Report a Problem"
            
            InitialComplaintImageView.layer.cornerRadius = 20
            InitialComplaintImageView.layer.borderColor = UIColor.systemGray.cgColor
            InitialComplaintImageView.layer.borderWidth = 1
            InitialComplaintImageView.contentMode = .scaleAspectFill
            InitialComplaintImageView.clipsToBounds = true
            
            [PhotoSelectorButton, CameraButton, analyzeButton, continueButton].forEach {
                $0?.layer.cornerRadius = 12
                $0?.clipsToBounds = true
            }
            
            analyzeButton.isEnabled = false
            continueButton.isHidden = true
            newAnalysisInstructionLabel.isHidden = true
            updateImageViewSize()
           // updateUIAfterAnalysis()
            addBorderToImageView()
        }
    
    private func updateButtonLayout() {
            let imageBottom = InitialComplaintImageView.frame.maxY + 20
            let buttonWidth = view.bounds.width * 0.4

            PhotoSelectorButton.frame = CGRect(x: 20, y: imageBottom, width: buttonWidth, height: 50)
            CameraButton.frame = CGRect(x: view.bounds.width - 20 - buttonWidth, y: imageBottom, width: buttonWidth, height: 50)

            analyzeButton.frame = CGRect(x: 20, y: PhotoSelectorButton.frame.maxY + 20, width: view.bounds.width - 40, height: 50)
            continueButton.frame = CGRect(x: 20, y: analyzeButton.frame.maxY + 20, width: view.bounds.width - 40, height: 50)

            problemStatementLabel.frame = CGRect(x: 20, y: continueButton.frame.maxY + 10, width: view.bounds.width - 40, height: 30)
            newAnalysisInstructionLabel.frame = CGRect(x: 20, y: problemStatementLabel.frame.maxY + 10, width: view.bounds.width - 40, height: 30)
        }
        
    private func setupGestures() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tapGesture)
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
        
            print("Getting here")
        
            let reportDetailView = ReportDetailView(problemName: problemName, initialImage: image, problemDescription: problemDescription)
            let hostingController = UIHostingController(rootView: reportDetailView)
            
            // Configure the hosting controller to use the navigation bar
            hostingController.title = "Report Detail"
            hostingController.navigationItem.largeTitleDisplayMode = .never
            
            navigationController?.pushViewController(hostingController, animated: true)
        }
    
    
//    @IBAction func showReportDetailSwiftUIView(_ sender: Any) {
//        guard let image = InitialComplaintImageView.image else { return }
//
//        print("Getting here")
//        let hostingVC = UIHostingController(rootView: ReportDetailView(problemName: problemName, initialImage: image, problemDescription: problemDescription))
//           
//      //  hostingVC.modalPresentationStyle = .fullScreen
//        
//       // present(hostingVC, animated: true, completion: nil)
//        
//        
//        navigationController?.pushViewController(hostingVC, animated: true)
//    }
    
    // MARK: - Helper Functions
    func addBorderToImageView() {
        if traitCollection.userInterfaceStyle == .dark {
            InitialComplaintImageView.layer.borderColor = UIColor.white.cgColor
        } else {
            InitialComplaintImageView.layer.borderColor = UIColor.black.cgColor
        }
        InitialComplaintImageView.layer.borderWidth = 3.0
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


struct InitialProblemDescriptionViewControllerRepresentable: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> InitialProblemDescriptionViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "InitialProblemDescriptionViewController") as! InitialProblemDescriptionViewController
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: InitialProblemDescriptionViewController, context: Context) {
        // Handle any updates if needed
    }
}

