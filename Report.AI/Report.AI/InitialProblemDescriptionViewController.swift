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
    
    @IBOutlet weak var AIProblemDescriptionTextFeild: UITextField!
    @IBOutlet weak var ContinueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    /// Allow the user to choose or take a photo from their camera
    @IBAction func photoSelectionOrCapture(_ sender: UIButton) {
        
    }
    


}

