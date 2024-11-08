//
//  ImageCropper.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/5/21.
//

import SwiftUI
import UIKit
import CropViewController

struct ImageCropper: UIViewControllerRepresentable{
    @Environment(\.presentationMode) private var presentationMode
    
    @Binding var image: UIImage?
    @Binding var visible: Bool
    var done: (UIImage) -> Void
    
    class Coordinator: NSObject, CropViewControllerDelegate{
        let parent: ImageCropper
        
        init(_ parent: ImageCropper){
            self.parent = parent
        }
        
        func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
            withAnimation{
                parent.visible = false
            }
            parent.done(image)
        }
        
        func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
            withAnimation{
                parent.visible = false
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let img = self.image ?? UIImage()
        let cropViewController = CropViewController(image: img)
        cropViewController.delegate = context.coordinator
        return cropViewController
    }
}
