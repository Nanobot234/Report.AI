//
//  ViewControllerExtension.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/10/24.




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


extension UIImage {
    func resized(to targetSize: CGSize) -> UIImage? {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height

        // Determine the scale factor to fit the image into the target size
        let scaleFactor = min(widthRatio, heightRatio)

        // Calculate the new size
        let newSize = CGSize(width: size.width * scaleFactor, height: size.height * scaleFactor)

        // Resize the image
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return resizedImage
    }
}


class SceneManager {
    static let shared = SceneManager()
    
    var windowScene: UIWindowScene? {
        UIApplication.shared.connectedScenes.first as? UIWindowScene
    }
}
