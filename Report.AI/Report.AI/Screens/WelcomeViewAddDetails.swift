//
//  WelcomeViewAddDetails.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 06/10/24.
//

import SwiftUI
import UIKit

// MARK: - View
struct WelcomeViewAddDetails: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @Binding var hasCompletedWelcome: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                headerView
                avatarView
                formFieldsView
                infoText
                Spacer()
                getStartedButton
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
    }
    
    private var headerView: some View {
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
    }
    
    private var avatarView: some View {
        Image(systemName: "person.crop.circle.badge.plus")
            .font(.system(size: 60))
            .foregroundColor(.teal)
            .padding(.bottom, 10)
    }
    
    private var formFieldsView: some View {
        VStack(spacing: 20) {
            FormField(icon: "person.fill", title: "Name", text: $viewModel.nameOfUser)
            FormField(icon: "envelope.fill", title: "Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
            FormField(icon: "phone.fill", title: "Contact", text: $viewModel.contactNo)
                .keyboardType(.phonePad)
            FormField(icon: "location.fill", title: "Address", text: $viewModel.location)
        }
        .padding(.horizontal)
    }
    
    private var infoText: some View {
        Text("You can update these details later in Settings")
            .font(.subheadline)
            .foregroundColor(.secondary)
            .padding(.top)
    }
    
    private var getStartedButton: some View {
        Button(action: {
            viewModel.saveUserDetails()
            hasCompletedWelcome = true
            // Remove the direct navigation call
            // viewModel.navigateToInitialProblemDescription()
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
}

// MARK: - ViewModel
class WelcomeViewModel: ObservableObject {
    @Published var nameOfUser: String = ""
    @Published var email: String = ""
    @Published var contactNo: String = ""
    @Published var location: String = ""
    @Published var profileImage: UIImage?
    
    @AppStorage("userName")  var storedNameOfUser: String = ""
    @AppStorage("userEmail")  var storedEmail: String = ""
    @AppStorage("userContactNo")  var storedContactNo: String = ""
    @AppStorage("userAddress")  var storedAddress: String = ""
    
    init() {
        loadUserDetails()
        loadProfileImage()
    }
    
    func loadUserDetails() {
        nameOfUser = storedNameOfUser
        email = storedEmail
        contactNo = storedContactNo
        location = storedAddress
    }
    
    func saveUserDetails() {
        storedNameOfUser = nameOfUser
        storedEmail = email
        storedContactNo = contactNo
        storedAddress = location
    }
    
    func clearProfileImage() {
        UserDefaults.standard.removeObject(forKey: "userProfileImage")
        self.profileImage = nil
    }
    
    func saveProfileImage(_ image: UIImage?) {
        guard let image = image else {
            clearProfileImage()
            return
        }
        
        if let imageData = image.jpegData(compressionQuality: 0.8) {
            UserDefaults.standard.set(imageData, forKey: "userProfileImage")
            self.profileImage = image
        }
    }
    
    private func loadProfileImage() {
        if let imageData = UserDefaults.standard.data(forKey: "userProfileImage"),
           let image = UIImage(data: imageData) {
            self.profileImage = image
        }
    }
    
    func navigateToInitialProblemDescription() {
        if let window = SceneManager.shared.windowScene?.windows.first {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let initialVC = storyboard.instantiateViewController(withIdentifier: "InitialProblemDescriptionViewController")
            window.rootViewController = initialVC
            window.makeKeyAndVisible()
        }
    }
}

// MARK: - Supporting Views
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

// MARK: - Preview
struct WelcomeView_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeViewAddDetails(hasCompletedWelcome: .constant(false))
    }
}

// MARK: - Utilities
extension View {
    func isPreview() -> Bool {
        ProcessInfo.processInfo.environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    }
}
