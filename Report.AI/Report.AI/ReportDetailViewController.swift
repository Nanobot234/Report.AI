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
        
        InitialimageImageView.image = initialImage
        
        self.hideKeyboardWhenTappedAround()
        
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
