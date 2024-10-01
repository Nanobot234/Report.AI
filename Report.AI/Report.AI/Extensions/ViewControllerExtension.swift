//
//  ViewControllerExtension.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/10/24.
//

import Foundation
import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            tapGesture.cancelsTouchesInView = false // Allows taps on other UI elements
            view.addGestureRecognizer(tapGesture)
        }
        
        @objc func dismissKeyboard() {
            view.endEditing(true)
        }
}

extension UserDefaults {
    
    func getAnalyzedProblemName() -> String {
        
        return UserDefaults.standard.string(forKey: "problemName")! //could be bettter but
    }
}

