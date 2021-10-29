//
//  UserProfile.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct UserProfile: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var photoModel: PhotoModel
    @State var profileEditingToBeDone: Bool = false
    @State var settingsDone: Bool = false
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment:.center) {
                
                VStack {
                    Image(uiImage: photoModel.downloadedPhotos.count == Array(Set(photoModel.downloadedPhotosURLs)).count ? photoModel.downloadedPhotos.sorted { $0.id! < $1.id! }[0].image! : UIImage())
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200, alignment: .center)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                        .overlay(Circle().stroke(Color.red, lineWidth: 5))
                    
                    Text("\(profileModel.userProfile.firstName ?? "temp"),\(profileModel.userProfile.age ?? 25)")
                        .font(.title)
                    
                    Spacer()
                }.padding(.top,50)
                
                
                // Settings, Edit Profile and Safety
                HStack(spacing:50) {
                    
                    NavigationLink(isActive: $settingsDone) {
                        return UserSettingView(settingsDone: $settingsDone)
                    } label: {
                        Button {
                            settingsDone = true
                        } label: {
                            Image(systemName: "gearshape.fill")
                                .resizable()
                                .frame(width:40, height:40)
                                .foregroundColor(Color.purple)
                                .padding(.bottom,20)
                        }
                    }
                    
                    NavigationLink(isActive: $profileEditingToBeDone) {
                        return EditProfile(profileEditingToBeDone: $profileEditingToBeDone)
                            .environmentObject(photoModel)
                            .environmentObject(profileModel)
                    } label: {
                        Button {
                            profileEditingToBeDone = true
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .resizable()
                                .frame(width:45, height:45)
                                .foregroundColor(Color.orange)
                        }
                    }
                    
                    NavigationLink(
                        destination: UserSafetyView(),
                        label: {
                            Image(systemName: "shield.fill")
                                .resizable()
                                .frame(width:40, height:40)
                                .foregroundColor(Color.purple)
                                .padding(.bottom,20)
                        })
                    
                }
                .padding(.bottom,30)
                
                // Subscription details
                SubscriptionDetails()
                
            }
            .padding(.horizontal,20)
            .navigationBarHidden(true)
        }
        
    }
}


struct UserProfile_Previews: PreviewProvider {
    
    static var previews: some View {
        UserProfile()
            .environmentObject(ProfileViewModel())
            .environmentObject(PhotoModel())
    }
}
