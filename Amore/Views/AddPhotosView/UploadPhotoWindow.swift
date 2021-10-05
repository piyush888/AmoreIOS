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
    
    @Binding var image : UIImage?
    @State private var showSheet = false
    @State var activeSheet: ActiveSheet? = .imageChoose
    
    
    func imageCropped(image: UIImage){
       self.image = image
        showSheet = false
     }

    var body: some View {
        
        VStack {
            
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 115, height: 170, alignment: .center)
                    .clipped()
                    .cornerRadius(5.0)
                    .background(Color.pink.opacity(0.2))
                    .shadow(color: Color("onboarding-pink"),
                            radius: 2, x: 3, y: 3)
                    .clipShape(Rectangle())
            } else {
                Image(uiImage: UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 115, height: 170, alignment: .center)
                    .clipped()
                    .cornerRadius(5.0)
                    .background(Color.pink.opacity(0.2))
                    .shadow(color: Color("onboarding-pink"),
                            radius: 2, x: 3, y: 3)
                    .clipShape(Rectangle())
            }
            
        
           HStack {
                Image(systemName:"plus.circle.fill")
                    .resizable()
                    .frame(width:20, height:20)
                    .foregroundColor(.pink)
                    .onTapGesture {
                        showSheet = true
                        activeSheet = .imageChoose
                    }
                
                // Don't show if the image is nil
                if image != nil {
                    Image(systemName:"pencil.circle.fill")
                        .resizable()
                        .frame(width:20, height:20)
                        .foregroundColor(.pink)
                        .onTapGesture {
                            showSheet = true
                            activeSheet = .cropImage
                        }
                    
                    Image(systemName:"trash.circle.fill")
                        .resizable()
                        .frame(width:20, height:20)
                        .foregroundColor(.pink)
                        .onTapGesture {
                            image = nil
                        }
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
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}


