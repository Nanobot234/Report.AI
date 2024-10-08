//
//  CameraSelectionStructs.swift
//  Report.AI
//
//  Created by Nana Bonsu on 9/26/24.
//

import Foundation
import SwiftUI
import PhotosUI

/// Struct to allow the a user to select multiple images to add
struct PhotoPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    @Binding var description: String
    let updateArray: () -> ()
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 2
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
                
                // Now the task will run after all images are loaded
              
            
                self.parent.description = await GeminiManager.shared.updateProblemDescriptionWithImages(input: self.parent.images).replacingOccurrences(of: "\'", with: "\'") //get rid of slashes
              
            }
        }

        func loadImage(from result: PHPickerResult) async -> UIImage? {
            return await withCheckedContinuation { continuation in
                result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                    continuation.resume(returning: image as? UIImage)
                }
            }
        }

        }
}


/// Enables users to take photos and add them to an array of photos
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage] //the image list that your adding to
   

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
              
              
              picker.dismiss(animated: true) // Close camera after capturing an image
          }

          func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
              picker.dismiss(animated: true)
          }
      }
}
