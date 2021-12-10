//
//  CardImages.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct CardImages: View {
    
    @Binding var profileImage: ProfileImage?
    @Binding var photoStruct: Photo
    @State var width: CGFloat
    @State var height: CGFloat
    @State var testing: Bool
    
    
    func getImage(imageURL: URL, onFailure: @escaping () -> Void, onSuccess: @escaping (_ image: UIImage) -> Void) {
        SDWebImageManager.shared.loadImage(with: imageURL, options: [.continueInBackground], progress: nil) { image, data, error, cacheType, finished, durl in
            if let err = error {
                print(err)
                return
            }
            guard let image = image else {
                // No image handle this error
                onFailure()
                return
            }
            if finished {
                onSuccess(image)
            }

        }
    }
    
    var body: some View {
        VStack {
            
            if testing {
                // If testing for UI building
                
                Image("onboarding_girl4")
                  .resizable()
                  .scaledToFill()
                  .frame(width: width, height:height)
                  .cornerRadius(20)
            } else {
                
                // If we are not testing
                Image(uiImage: photoStruct.downsampledImage ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height:height)
                    .onAppear {
                        if photoStruct.downsampledImage == nil {
                            if let imageURL = profileImage?.imageURL {
                                getImage(imageURL: imageURL) {
                                    return
                                } onSuccess: { downloadedImage in
//                                    photoStruct = Photo(image: nil, downsampledImage: downloadedImage.downsample(to: CGSize(width: geometry.size.width, height: geometry.size.height/1.5)), inProgress: false)
                                    photoStruct = Photo(image: nil, downsampledImage: downloadedImage, inProgress: false)
                                    SDImageCache.shared.removeImage(forKey: imageURL.absoluteString) {
                                        print("Successfully deleted card image cache for : ", profileImage?.firebaseImagePath?.split(separator: "/")[1])
                                    }
                                }
                            }
                        }
                    }
                 
            }
            
            
        }
    }
}


struct CardImages_Previews: PreviewProvider {
    static var previews: some View {
        
        let tempProfile = CardProfileWithPhotos(id: "Test123456",
                              firstName: "Neha",
                              lastName: "Sharma",
                              dateOfBirth: "October 14, 2021",
                              interests: ["Running","Gaming","Helping"],
                              sexualOrientation: ["Straight"],
                              sexualOrientationVisible: true,
                              showMePreference: "Women",
                              work: "Bank of America",
                              school: "Harvard University",
                              age: 25,
                              headline: "Hey Pumpkin",
                              profileDistanceFromUser: 0,
                              jobTitle: "VP",
                              workType: "Remove this field",
                              height: 5.6,
                              education: "Masters in Science",
                              religion: "Hindu",
                              community: "Brahmin",
                              politics: "Liberal",
                              location: "Coordinates",
                              description: "this field is description",
                              country: "India",
                              image1: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637162606.404443.heic?alt=media&token=b91a59f4-1b39-4b28-b972-9d4d5252fd76"),
                                                   firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637162606.404443.heic"),
                              image2: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637162885.375509.heic?alt=media&token=632dde36-746c-4dc4-8e83-5b19e85f6d82"),
                                                   firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637162885.375509.heic"),
                              image3: ProfileImage(imageURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/amore-f8cd6.appspot.com/o/images%2FQvV4OoZmZ3QWHhMNaZrr7lkqmLF3%2Fimage1637233645.380225.heic?alt=media&token=5280b317-0f00-4544-9a78-70ebc1e8ee7a"), firebaseImagePath: "images/QvV4OoZmZ3QWHhMNaZrr7lkqmLF3/image1637233645.380225.heic"),
                              doYouWorkOut: "Yes",
                              doYouDrink: "No",
                              doYouSmoke: "Yes",
                              doYouWantBabies: "No")
        
        GeometryReader { geometry in
            CardImages(profileImage: Binding.constant(tempProfile.image6),
                       photoStruct: Binding.constant(tempProfile.photo6.boundPhoto),
                       width:geometry.size.width-10,
                       height:geometry.size.height/2,
                       testing:true)
                .padding()
        }
        
    }
}
