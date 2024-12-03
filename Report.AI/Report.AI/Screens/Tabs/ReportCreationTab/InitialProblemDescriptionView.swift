import UIKit
import SwiftUI

class InitialProblemDescriptionViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var InitialComplaintImageView: UIImageView!
    @IBOutlet weak var PhotoSelectorButton: UIButton!
    @IBOutlet weak var problemStatementLabel: UILabel!
    @IBOutlet weak var newAnalysisInstructionLabel: UILabel!
    @IBOutlet weak var ReportDestinationLabel: UILabel!
    @IBOutlet weak var ReportDestinationTextFeild: UITextField!
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
    private var activityIndicatorHostingController: UIHostingController<ActivityIndicator>?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.hideKeyboardWhenTappedAround()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateImageViewSize()
    }

    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        addBorderToImageView()
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

        problemStatementLabel.text = "" // Clear any text
        analyzeButton.isEnabled = false
        continueButton.isHidden = true
        ReportDestinationLabel.isHidden = true
        ReportDestinationTextFeild.isHidden = true

        newAnalysisInstructionLabel.text = "Take a photo or select an image of the problem you want to report.\nThen click Analyze."
        updateImageViewSize()
        addBorderToImageView()
        
        ReportDestinationTextFeild.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    private func updateImageViewSize() {
        // Adjust image view size if needed
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

        showCustomActivityIndicator(with: "Analyzing Image")
        Task {
            let result = await GeminiManager.shared.generateProblemAndDescriptionFromImage(input: addedImage)
            problemName = result?[0] ?? ""
            problemDescription = result?[1] ?? ""
            updateUIAfterAnalysis()
            hideActivityIndicator()
        }
    }

    @IBAction func showReportDetailSwiftUIView(_ sender: Any) {
        guard let image = InitialComplaintImageView.image else { return }
        
        let reportDestination = ReportDestinationTextFeild.text ?? ""
        let reportDetailView = ReportDetailView(problemName: problemName, reportingTo: reportDestination, initialImage: image, problemDescription: problemDescription)
        let hostingController = UIHostingController(rootView: reportDetailView)

        hostingController.title = "Report Detail"
        hostingController.navigationItem.largeTitleDisplayMode = .never

        navigationController?.pushViewController(hostingController, animated: true)
    }

    // MARK: - Helper Functions
    func addBorderToImageView() {
        let borderColor: UIColor = traitCollection.userInterfaceStyle == .dark ? .white : .black
        InitialComplaintImageView.layer.borderColor = borderColor.cgColor
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
        continueButton.isEnabled = false
        analyzeButton.isEnabled = false
        ReportDestinationLabel.isHidden = false
        ReportDestinationTextFeild.isHidden = false

        newAnalysisInstructionLabel.text = "Select a new image to make another analysis"
        activityIndicatorHostingController?.view.isHidden = true // Stop showing the activity indicator
    }

    // Image Picker Configuration
    func initializeImagePickerController(with sourceType: UIImagePickerController.SourceType) {
        imagePickerController = UIImagePickerController()
        imagePickerController!.delegate = self
        imagePickerController!.sourceType = sourceType
        imagePickerController!.allowsEditing = true
        present(imagePickerController ?? UIImagePickerController(), animated: true, completion: nil)
    }

    // Show activity indicator while processing
    func showCustomActivityIndicator(with text: String) {
        let activityIndicator = ActivityIndicator(text: text)
        let activityHC = UIHostingController(rootView: activityIndicator)
        activityHC.view.frame = view.bounds
        activityHC.view.translatesAutoresizingMaskIntoConstraints = false

        addChild(activityHC)
        view.addSubview(activityHC.view)
        activityHC.didMove(toParent: self)

        // Centering the activity indicator
        NSLayoutConstraint.activate([
            activityHC.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityHC.view.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])

        // Keep a reference to the hosting controller to remove it later
        self.activityIndicatorHostingController = activityHC
    }

    func hideActivityIndicator() {
        activityIndicatorHostingController?.view.removeFromSuperview()
        activityIndicatorHostingController = nil
    }

    @objc func textFieldDidChange() {
        // Enable the button only if the text field is not empty
        continueButton.isEnabled = !(ReportDestinationTextFeild.text?.isEmpty ?? true)
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
        }

        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - SwiftUI Hosting View
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

