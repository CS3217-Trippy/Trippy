//
//  ImagePicker.swift
//  Trippy
//
//  Created by QL on 20/3/21.
//

import UIKit
import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {

    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedImage: UIImage?
    @Environment(\.presentationMode) private var presentationMode

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                                context: UIViewControllerRepresentableContext<ImagePicker>) {
        // Do nothing
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo
                                    info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.editedImage] as? UIImage {
                parent.selectedImage = formatImage(image: image)
            } else if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = formatImage(image: image)
            }

            parent.presentationMode.wrappedValue.dismiss()
        }

        private func formatImage(image: UIImage) -> UIImage {
            if image.size.width != image.size.height {
                return image.cropsToSquare()
            } else {
                return image
            }
        }
    }
}
