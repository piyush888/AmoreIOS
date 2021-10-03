//
//  UploadPhotoWindow.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.
//

import SwiftUI

struct UploadPhotoWindow: View {
    
    @State var image = UIImage()
    @State private var showSheet = false
    
    var body: some View {
        
        ZStack{
            Image(uiImage: self.image)
                .resizable()
                .frame(height:170)
                .cornerRadius(5.0)
                .background(Color.pink.opacity(0.2))
                .shadow(color: Color("onboarding-pink"),
                        radius: 2, x: 3, y: 3)
                .clipShape(Rectangle())
                .onTapGesture {showSheet = true}
            
            Image(systemName:"plus.circle.fill")
                .resizable()
                .frame(width:30, height:30)
                .foregroundColor(.pink)
                .onTapGesture {showSheet = true}
        }
        .sheet(isPresented: $showSheet) {
            // Pick an image from the photo library:
            ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            //  If you wish to take a photo from camera instead:
            // ImagePicker(sourceType: .camera, selectedImage: self.$image)
        }
    }
}

struct UploadPhotoWindow_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoWindow(image: UIImage())
    }
}
