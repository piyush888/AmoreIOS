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
    @State var image1 : UIImage?
    @State var image2 : UIImage?
    @State var image3 : UIImage?
    @State var image4 : UIImage?
    @State var image5 : UIImage?
    @State var image6 : UIImage?
    
    @State private var disableButton = false
    @State private var counter = 0
    
    @State var showsAlert = false
    
    func imagesUploadedByUser() {
        counter = 0
        counter = counter + (image1 != nil ? 1 : 0)
        counter = counter + (image2 != nil ? 1 : 0)
        counter = counter + (image3 != nil ? 1 : 0)
        counter = counter + (image4 != nil ? 1 : 0)
        counter = counter + (image5 != nil ? 1 : 0)
        counter = counter + (image6 != nil ? 1 : 0)
    }
    
    func resizeImagesAndUpload() {
        let images = [image1, image2, image3, image4, image5, image6]
        for (index, image) in images.enumerated() {
            if image != nil {
//                guard let image = image?.compressedData() else { return }
                do {
                    guard let imageData = try image?.heicData(compressionQuality: CGFloat(0.6)) else { return }
                    FirestoreServices.uploadImage(imageData: imageData, filename: "image\(index+1)")
                }
                catch {
                    print(error)
                }
            }
        }
    }
    
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
                UploadPhotoWindow(image: self.$image1)
                UploadPhotoWindow(image: self.$image2)
                UploadPhotoWindow(image: self.$image3)
                UploadPhotoWindow(image: self.$image4)
                UploadPhotoWindow(image: self.$image5)
                UploadPhotoWindow(image: self.$image6)
            })
            .padding(.horizontal)
         
            Spacer()
            
            Button{
                // Update the counter
                imagesUploadedByUser()
                // Store the images in the firestore database
                if counter >= 2 {
                    // Update to firestore
                    print("Updating to firestore...")
                    resizeImagesAndUpload()
                } else {
                    showsAlert = true
                    print("Alert atleast 2 photos are required")
                }
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
        .alert(isPresented: self.$showsAlert) {
                   Alert(title: Text(""),message: Text("Atleast 2 photos are required"))
               }
        .padding(20)
    }
}

struct AddPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        AddPhotosView()
    }
}
