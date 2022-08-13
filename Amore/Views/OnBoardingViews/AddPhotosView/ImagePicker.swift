//
//  ImagePicker.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var selectedPhoto: Photo
    @Binding var newPhotoChosen: Bool
    var done: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {

        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator

        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: UIViewControllerRepresentableContext<ImagePicker>) {

    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

        var parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                let heightInPoints = image.size.height
//                let heightInPixels = heightInPoints * image.scale
                let widthInPoints = image.size.width
//                let widthInPixels = widthInPoints * image.scale
                
                parent.selectedPhoto.image = image.fixedOrientation
                parent.selectedPhoto.downsampledImage = image.fixedOrientation.downsample(to: CGSize(width: widthInPoints/5,
                                                                                                     height: heightInPoints/5))
                parent.newPhotoChosen = true
                parent.done()
            }
            parent.presentationMode.wrappedValue.dismiss()
        }

    }
}
