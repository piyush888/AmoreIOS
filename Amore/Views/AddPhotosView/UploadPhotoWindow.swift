//
//  UploadPhotoWindow.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.
//

import SwiftUI

enum ActiveSheet: Identifiable {
    case imageChoose, cropImage
    var id: Int {
        hashValue
    }
}

struct UploadPhotoWindow: View {
    
    @State var uploadedImage = UIImage()
    @State var displayImage = UIImage()
    
    @State private var showSheet = false
    
    var originalImage = UIImage(named: "food")
    @State var croppedImage:UIImage?
    @State var activeSheet: ActiveSheet? = .imageChoose
    
    var body: some View {
        
        VStack {
            
            Image(uiImage: displayImage)
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
        }.sheet(isPresented: $showSheet, onDismiss: {
            if self.activeSheet == .imageChoose {
                displayImage = uploadedImage
            }
            else if self.activeSheet == .cropImage {
                displayImage = croppedImage!
            }
        }) {
            if self.activeSheet == .imageChoose {
                // Pick an image from the photo library:
                //  If you wish to take a photo from camera instead:
                // ImagePicker(sourceType: .camera, selectedImage: self.$image)
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$uploadedImage)
            }
            else if self.activeSheet == .cropImage {
                ImageCroppingView(shown: $showSheet, image: self.uploadedImage, croppedImage: $croppedImage)
            }
        }
    }
}

struct UploadPhotoWindow_Previews: PreviewProvider {
    static var previews: some View {
        UploadPhotoWindow(displayImage: UIImage())
    }
}
