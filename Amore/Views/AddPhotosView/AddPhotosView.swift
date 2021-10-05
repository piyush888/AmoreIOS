//
//  AddPhotosView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/3/21.

// Array of Images: https://stackoverflow.com/questions/66323020/swiftui-display-an-array-of-image
// Save image with core data : https://www.hackingwithswift.com/forums/swiftui/saving-images-with-core-data-in-swiftui/1241


import SwiftUI

struct AddPhotosView: View {
    
    // All the 6 images that we give user an option to upload
    @State private var image1 = UIImage()
    @State private var image2 = UIImage()
    @State private var image3 = UIImage()
    @State private var image4 = UIImage()
    @State private var image5 = UIImage()
    @State private var image6 = UIImage()
    
    @State private var disableButton = true
    
    let adaptivecolumns = Array(repeating:
                                GridItem(.adaptive(minimum: 150),spacing: 5,
                                         alignment: .center),count: 3)
    
    var body: some View {
        
        VStack {
            
            Text("Add photos")
                .font(.BoardingTitle)
                .padding(.top,70)
            
            Text("Add at least 2 photos to continue")
                .font(.BoardingSubHeading)
                .padding(.horizontal,20)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40)
                
            
            // Give the user options to add photos
            LazyVGrid(columns: adaptivecolumns, content: {
                UploadPhotoWindow(image: image1)
                UploadPhotoWindow(image: image2)
                UploadPhotoWindow(image: image3)
                UploadPhotoWindow(image: image4)
                UploadPhotoWindow(image: image5)
                UploadPhotoWindow(image: image6)
            })
            .padding(.horizontal)
         
            Spacer()
            
            Button{
                // Store the images in the firestore database
                print(disableButton)
            } label : {
                ZStack{
                    Rectangle()
                        .frame(height:45)
                        .cornerRadius(5.0)
                        .foregroundColor(disableButton ? .gray : .pink)
                        
                    Text("Continue")
                        .foregroundColor(.white)
                        .bold()
                        .font(.BoardingButton)
                }
            }
            .disabled(disableButton)
            .padding(.horizontal,50)
        }
        .padding(20)
    }
}

struct AddPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotosView()
    }
}
