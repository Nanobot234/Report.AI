//
//  ProfileView.swift
//  Report.AI
//
//  Created by Yashraj Jadhav on 16/10/24.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    @StateObject private var viewModel = WelcomeViewModel()
    @State private var isPhotoPickerPresented = false
    @State private var isEditMode = false
    @State private var showingActionSheet = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                profileImageSection
                userInformationSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground).ignoresSafeArea())
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Menu {
                    Button(action: {
                        withAnimation(.spring()) {
                            isEditMode.toggle()
                        }
                    }) {
                        Label(isEditMode ? "Done Editing" : "Edit Profile", systemImage: "pencil")
                    }
                    
                    Button(role: .destructive, action: {
                        withAnimation { viewModel.clearProfileImage() }
                    }) {
                        Label("Clear Profile Picture", systemImage: "trash")
                    }
                    
                    Button(role: .destructive, action: {
                        // Add logout action here
                    }) {
                        Label("Logout", systemImage: "rectangle.portrait.and.arrow.right")
                    }
                } label: {
                    Image(systemName: "pencil")
                        .imageScale(.large)
                        .foregroundColor(.teal)
                }
            }
        }
        .sheet(isPresented: $isPhotoPickerPresented) {
            SinglePhotoPicker(image: Binding(
                get: { viewModel.profileImage },
                set: { newImage in
                    withAnimation {
                        viewModel.saveProfileImage(newImage)
                    }
                }
            ))
        }
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("Profile Picture Options"),
                buttons: [
                    .default(Text("Change Picture")) { isPhotoPickerPresented = true },
                    .destructive(Text("Remove Picture")) {
                        withAnimation { viewModel.clearProfileImage() }
                    },
                    .cancel()
                ]
            )
        }
    }
    
    private var profileImageSection: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Group {
                    if let profileImage = viewModel.profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image("Anon")
                            .resizable()
                            .scaledToFill()
                    }
                }
                .frame(width: 160, height: 160)
                .clipShape(Circle())
                .overlay(Circle().stroke(Color.teal, lineWidth: 3))
                .shadow(radius: 10)
                .onTapGesture { showingActionSheet = true }
                
                Button(action: { isPhotoPickerPresented.toggle() }) {
                    ZStack {
                        Circle()
                            .fill(Color.teal)
                            .frame(width: 44, height: 44)
                        
                        Image(systemName: "camera")
                            .foregroundColor(.white)
                    }
                }
                .offset(x: 5, y: 5)
                .shadow(radius: 4)
            }
            
            if let name = viewModel.profileImage != nil ? viewModel.storedNameOfUser : nil {
                Text(name)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                    .padding(.top, 8)
            }
            
            Text("Joined \(formattedJoinDate)")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }
    
    private var userInformationSection: some View {
        VStack(spacing: 20) {
            infoCard(icon: "person.fill", title: "Name", value: $viewModel.storedNameOfUser)
            infoCard(icon: "envelope.fill", title: "Email", value: $viewModel.storedEmail)
            infoCard(icon: "phone.fill", title: "Contact", value: $viewModel.storedContactNo)
            infoCard(icon: "location.fill", title: "Address", value: $viewModel.storedAddress)
        }
    }
    
    private func infoCard(icon: String, title: String, value: Binding<String>) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.white)
                .font(.system(size: 18, weight: .semibold))
                .frame(width: 36, height: 36)
                .background(Color.teal)
                .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fontWeight(.medium)
                
                if isEditMode {
                    TextField("Enter \(title.lowercased())", text: value)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    Text(value.wrappedValue.isEmpty ? "Not provided" : value.wrappedValue)
                        .font(.body)
                }
            }
            
            Spacer()
            
            if isEditMode {
                Image(systemName: "pencil")
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
    
    private var formattedJoinDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: viewModel.joinDate)
    }
}

// Assume this is part of your WelcomeViewModel
extension WelcomeViewModel {
    var joinDate: Date {
        // Replace this with actual logic to get the user's join date
        return Date() // This is just a placeholder
    }
}



struct SinglePhotoPicker: UIViewControllerRepresentable {
    @Binding var image: UIImage? // The selected image
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 1 // Allow only one image
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: SinglePhotoPicker

        init(_ parent: SinglePhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            Task {
                if let result = results.first {
                    self.parent.image = await self.loadImage(from: result)
                }
            }
        }

        func loadImage(from result: PHPickerResult) async -> UIImage? {
            return await withCheckedContinuation { continuation in
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                        continuation.resume(returning: nil)
                    } else {
                        continuation.resume(returning: image as? UIImage)
                    }
                }
            }
        }
    }
}
// Preview
struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ProfileView()
        }
    }
}
