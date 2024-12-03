import Foundation
import SwiftUI
import PhotosUI

/// Struct to allow the user to select multiple images to add
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var description: String
    @Binding var showLoadingIndicator: Bool

    let updateReport: () -> ()

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 2 // Limit to 2 images
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPicker

        init(_ parent: PhotoPicker) {
            self.parent = parent
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            // Start loading the images
            self.parent.showLoadingIndicator = true

            // Use Task to handle asynchronous image loading
            Task {
                // Create a task group to handle multiple asynchronous image loads
                await withTaskGroup(of: UIImage?.self) { group in
                    for result in results {
                        group.addTask {
                            return await self.loadImage(from: result)
                        }
                    }
                    
                    // Collect all images after all tasks in the group finish
                    for await image in group {
                        if let image = image {
                            self.parent.images.append(image)
                        }
                    }
                }
                
                // Once all images are loaded, update the problem description
                self.parent.description = await GeminiManager.shared.updateProblemDescriptionWithImages(input: self.parent.images)
                    .replacingOccurrences(of: "\'", with: "\'") // Handle single quote issues

                // Update the report
                self.parent.updateReport()

                // Hide the loading indicator after the update is complete
                self.parent.showLoadingIndicator = false
            }
        }

        func loadImage(from result: PHPickerResult) async -> UIImage? {
            return await withCheckedContinuation { continuation in
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    if let error = error {
                        print("Error loading image: \(error.localizedDescription)")
                    }
                    continuation.resume(returning: image as? UIImage)
                }
            }
        }
    }
}

/// Enables users to take photos and add them to an array of photos
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage] // The image list to which you will add the captured image

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraPicker

        init(parent: CameraPicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.images.append(image)
            }
            picker.dismiss(animated: true) // Close the camera after capturing an image
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

