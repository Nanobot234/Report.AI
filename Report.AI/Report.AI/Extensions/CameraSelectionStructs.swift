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

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 0
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

                for result in results {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        }
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
