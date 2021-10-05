//
//  UploadPhotoWindow.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.
//

import SwiftUI
import CropViewController

enum ActiveSheet: Identifiable {
    case imageChoose, cropImage
    var id: Int {
        hashValue
    }
}

struct UploadPhotoWindow: View {
    
    @State var image : UIImage?
    @State private var showSheet = false
    @State var activeSheet: ActiveSheet? = .imageChoose
    
    
    func imageCropped(image: UIImage){
       self.image = image
        showSheet = false
     }

    var body: some View {
        
        VStack {
            
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(height:170, alignment: .center)
                .cornerRadius(5.0)
                .background(Color.pink.opacity(0.2))
                .shadow(color: Color("onboarding-pink"),
                        radius: 2, x: 3, y: 3)
                .clipShape(Rectangle())
        
           
            HStack {
                Image(systemName:"plus.circle.fill")
                    .resizable()
                    .frame(width:30, height:30)
                    .foregroundColor(.pink)
                    .onTapGesture {
                        showSheet = true
                        activeSheet = .imageChoose
                    }
                
                Image(systemName:"pencil.circle.fill")
                    .resizable()
                    .frame(width:30, height:30)
                    .foregroundColor(.pink)
                    .onTapGesture {
                        showSheet = true
                        activeSheet = .cropImage
                }
            }
        }.sheet(isPresented: $showSheet) {
            if self.activeSheet == .imageChoose {
                // Pick an image from the photo library:
                // If you wish to take a photo from camera instead:
                // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            }
            else if self.activeSheet == .cropImage {
                // Option to Crop the image
                ImageCropper(image: self.$image, visible: self.$showSheet, done: self.imageCropped)
                    .zIndex(10)
            }
        }
    }
}


struct UploadPhotoWindow_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoWindow(image: UIImage())
    }
}
