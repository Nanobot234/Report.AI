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
        

        return UserDefaults.standard.string(forKey: "problemName") ?? ""//could be bettter but
    }
    
    //
    /// saves a new user
    /// - Parameter newUser: the new `User` object to save
    func saveUser(with user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: "currentUser")
        }
    }
    
    func editUserDetails() {
        //get user details and edit
        if let user = UserDefaults.standard.string(forKey: "currentUser") {
            //TODO: Edit details here
        }

    }
}

