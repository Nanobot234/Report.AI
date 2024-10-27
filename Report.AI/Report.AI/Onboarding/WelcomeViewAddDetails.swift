//
//  WelcomeViewAddDetails.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 06/10/24.
//

import UIKit
import SwiftUI

struct WelcomeViewAddDetails: View {
    @Binding var hasCompletedWelcome: Bool
    @Environment(\.dismiss) var dismiss
    
    @State private var nameOfUser: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    @State private var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @State private var contactNo: String = UserDefaults.standard.string(forKey: "userContactNo") ?? ""
    @State private var location : String = UserDefaults.standard.string(forKey: "userAddress") ?? ""
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                // Header
                VStack(spacing: 8) {
                    Text("Welcome!")
                        .font(.largeTitle.bold())
                    HStack(spacing: 5) {
                        Text("Tell us a bit")
                        Text("about yourself")
                            .foregroundColor(.teal)
                    }
                    .font(.title2)
                }
                .padding(.top, 40)
                
                // Avatar
                Image(systemName: "person.crop.circle.badge.plus")
                    .font(.system(size: 60))
                    .foregroundColor(.teal)
                    .padding(.bottom, 10)
                
                // Form Fields
                VStack(spacing: 20) {
                    FormField(icon: "person.fill", title: "Name", text: $nameOfUser)
                    FormField(icon: "envelope.fill", title: "Email", text: $email)
                        .textInputAutocapitalization(.never)
                        .keyboardType(.emailAddress)
                    FormField(icon: "phone.fill", title: "Contact", text: $contactNo)
                        .keyboardType(.phonePad)
                    FormField(icon: "location.fill", title: "Address", text: $location)
                }
                .padding(.horizontal)
                
                Text("You can update these details later in Settings")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.top)
                
                Spacer()
                
                Button(action: {
                    saveUserDetails()
                    hasCompletedWelcome = true
                    // Navigate to InitialProblemDescriptionViewController
                    navigateToInitialProblemDescription()
                    
                    //or can append to the routeNavStack
                }) {
                    HStack {
                        Text("Get Started")
                        Image(systemName: "arrow.right")
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.teal.gradient)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    // Save user details to UserDefaults
    private func saveUserDetails() {
        UserDefaults.standard.set(nameOfUser, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(contactNo, forKey: "userContactNo")
        UserDefaults.standard.set(contactNo, forKey: "userAddress")
    }
    
    // Navigate to InitialProblemDescriptionViewController
    private func navigateToInitialProblemDescription() {
        
        if let window = SceneManager.shared.windowScene?.windows.first {
        //here nmore!
            //window.rootViewController =
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialVC = storyboard.instantiateViewController(withIdentifier: "InitialProblemDescriptionViewController")
            window.rootViewController = initialVC
            window.makeKeyAndVisible()
            
        }
        
    }
}

// FormField View remains unchanged
struct FormField: View {
    let icon: String
    let title: String
    @Environment(\.colorScheme) var colorScheme
    @Binding var text: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.teal)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                TextField(title, text: $text)
                    .textFieldStyle(PlainTextFieldStyle())
            }
        }
        .padding()
        .background(
                    colorScheme == .dark
                    ? Color(UIColor.secondarySystemBackground)
                    : Color(.systemBackground)
                )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

// Preview
struct WelcomeViewAddDetails_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeViewAddDetails(hasCompletedWelcome: .constant(false))
    }
}
extension View {
    func isPreview() -> Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
