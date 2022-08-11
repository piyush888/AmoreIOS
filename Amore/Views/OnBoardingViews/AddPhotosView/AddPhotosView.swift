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
    @EnvironmentObject var photoModel: PhotoModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    @State var showsAlert = false
    
    let adaptivecolumns = Array(repeating: GridItem(.adaptive(minimum: 150),spacing: 5,
                                         alignment: .center),count: 3)
    
    
    var body: some View {
        
        GeometryReader { geo in
        
        VStack {
            
            uploadPhotosText
            
            // Give the user options to add photos
            ZStack {
                // Display Photos
                LazyVGrid(columns: adaptivecolumns, content: {
                    UploadWindowsGroup(width:geo.size.width/3.5,
                                       height:geo.size.height/4.8)
                        .environmentObject(profileModel)
                        .environmentObject(photoModel)
                    })
                    .disabled(photoModel.photoAction)
                    .grayscale(photoModel.photoAction ? 0.5 : 0)
                
                if photoModel.photoAction {
                    ProgressView()
                        .scaleEffect(x: 3, y: 3, anchor: .center)
                }
            }
            
            Spacer()
            buttonView
        
        }
        .alert(isPresented: self.$showsAlert) {
                   Alert(title: Text(""),message: Text("Atleast 2 photos are required"))
               }
        .padding(20)
        }
    }
    
    var uploadPhotosText: some View {
        
        VStack {
            Text("Add photos")
                .font(.title)
                
            Text("Add at least 2 photos to continue")
                .font(.footnote)
                .foregroundColor(Color.gray)
        }
        .multilineTextAlignment(.center)
        .padding(.bottom, 10)
        
    }
    
    var buttonView: some View {
        
        Button{
            // Store the images in the firestore database
            if profileModel.numOfUserPhotosAdded() >= 2 {
                // Update to firestore
                print("Continue to HomePage...")
                profileModel.checkMinNumOfPhotosUploaded()
            } else {
                showsAlert = true
                print("Alert atleast 2 photos are required")
            }
        } label : {
            ZStack{
                Rectangle()
                    .frame(height:45)
                    .cornerRadius(10.0)
                    .foregroundColor(profileModel.numOfUserPhotosAdded() < 2 ? .gray : .pink)
                
                Text("Continue")
                    .foregroundColor(.white)
                    
            }
        }
        .disabled(profileModel.numOfUserPhotosAdded() < 2)
        .padding(.horizontal,50)
    }
    
}

struct AddPhotosView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            AddPhotosView()
                .environmentObject(ProfileViewModel())
                .environmentObject(PhotoModel())
                .previewDisplayName("iPhone 13 Pro Max")
                .previewDevice("iPhone 13 Pro Max")
            
            AddPhotosView()
                .environmentObject(ProfileViewModel())
                .environmentObject(PhotoModel())
                .previewDisplayName("iPhone 13 Mini")
                .previewDevice("iPhone 13 Mini")
            
            AddPhotosView()
                .environmentObject(ProfileViewModel())
                .environmentObject(PhotoModel())
                .previewDisplayName("iPhone 12 Pro")
                .previewDevice("iPhone 12 Pro")
            
            AddPhotosView()
                .environmentObject(ProfileViewModel())
                .environmentObject(PhotoModel())
                .previewDisplayName("iPhone 11")
                .previewDevice("iPhone 11")
        }
        
        
    }
}
