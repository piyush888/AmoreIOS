//
//  TestCropper.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/4/21.
//

import SwiftUI

struct TestCropper: View {
    
    var originalImage = UIImage(named: "food")
    @State var croppedImage:UIImage?
    @State var cropperShown = false
    
    
    var body: some View {
        VStack{
            Spacer()
            Text("Original")
            Image(uiImage: originalImage!)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
            Spacer()
            if croppedImage != nil {
                Text("Cropped")
                Image(uiImage: croppedImage!)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                Spacer()
            }
            
            Button(action: {cropperShown = true}){
                Text("Go to cropper")
            }
            
            Spacer()
        }
        .sheet(isPresented: $cropperShown){
            ImageCroppingView(shown: $cropperShown, image: originalImage!, croppedImage: $croppedImage)
        }
    }
}

struct TestCropper_Previews: PreviewProvider {
    static var previews: some View {
        TestCropper()
    }
}
