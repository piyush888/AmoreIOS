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
                        .shadow(color: Color.pink, radius: 5, x: 0.5, y: 0.5)
                        
                    
                    Text("\(profileModel.userProfile.firstName ?? "Kshitiz"), \(profileModel.userProfile.age ?? 25)")
                        .font(.title2)
                    
                    Text("\(profileModel.userProfile.jobTitle ?? "Software Developer") at \(profileModel.userProfile.work ?? "Amore")")
                        .font(.caption)
                    
                    Text("Attended \(profileModel.userProfile.school ?? "Brightlands School")")
                        .font(.caption)
                    
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
                            
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing)
                                .frame(width:60, height:60)
                                .mask(Image(systemName: "gearshape.fill")
                                        .font(.system(size:40)))
                                .padding(.bottom,20)
                            
                        }
                    }
                    
                    NavigationLink(isActive: $profileEditingToBeDone) {
                        return EditProfile(profileEditingToBeDone: $profileEditingToBeDone)
                            .environmentObject(photoModel)
                            .environmentObject(profileModel)
                    } label: {
                        
                        LinearGradient(
                            gradient: Gradient(colors: [Color.gray, Color.purple]),
                            startPoint: .leading,
                            endPoint: .trailing)
                            .frame(width:60, height:60)
                            .mask(Image(systemName: "pencil.circle.fill")
                                    .font(.system(size:40)))
                       
                    }
                    
                    NavigationLink(
                        destination: UserSafetyView(),
                        label: {
                            
                            LinearGradient(
                                gradient: Gradient(colors: [Color.gray, Color.purple]),
                                startPoint: .leading,
                                endPoint: .trailing)
                                .frame(width:60, height:60)
                                .mask(Image(systemName: "shield.fill")
                                        .font(.system(size:40)))
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
