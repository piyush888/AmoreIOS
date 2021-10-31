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
    
    @State var showModal = false
    
    @State var popUpCardSelection: PopUpCards = .superLikeCards
    
    
    var body: some View {
        
        NavigationView {
            
            ZStack {
                VStack(alignment:.center) {
                    
                    // User Data
                    /// Image
                    /// Where user works
                    /// School Attended
                    UserSnapDetails()
                        .environmentObject(photoModel)
                        .environmentObject(profileModel)
                    
                    
                    // User Setttings View
                    /// Settings
                    /// Edit Profile
                    /// Safety
                    SettingEditProfileSafety(settingsDone:$settingsDone,
                                             profileEditingToBeDone:$profileEditingToBeDone)
                        .environmentObject(photoModel)
                        .environmentObject(profileModel)
                        .padding(.bottom,20)
                    
                    // Subscription details
                    /// SuperLike
                    /// Number Of Boosst Left
                    /// Upgrade
                    SubscriptionDetails(popUpCardSelection:$popUpCardSelection,
                                        showModal:$showModal,
                                        bgColor:Color(red: 0.80, green: 1.0, blue: 1.0))
                    
                    Spacer()
                    
                    // Subscription Options
                    /// User subscription amore
                    /// Amore Platinum Information
                    ///  Amore Gold Information
                    ZStack {
                        Spacer()
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(red: 0.80, green: 1.0, blue: 1.0))
                        VStack {
                            MyAmore(width: 300,
                                    popUpCardSelection:$popUpCardSelection,
                                    showModal: $showModal)
                            AmorePlatinum(width:300,
                                          popUpCardSelection:$popUpCardSelection,
                                          showModal:$showModal)
                            AmoreGold(width:300,
                                      popUpCardSelection:$popUpCardSelection,
                                      showModal:$showModal)
                                .padding(.bottom,10)
                        }
                        
                        Spacer()
                    }
                    
                }
                .padding(.horizontal,20)
                .navigationBarHidden(true)
                
                
                if showModal {
                    
                    switch popUpCardSelection {
                        
                    case .superLikeCards :
                        SuperLikeCard(showModal: $showModal)
                        
                    case .boostCards :
                        BoostCard(showModal: $showModal)
                    
                    case .messagesCards:
                        MessageCard(showModal: $showModal)
                        
                    case .myAmorecards:
                        MyAmoreCard(showModal: $showModal,
                                    popUpCardSelection:$popUpCardSelection)
                        
                    case .amorePlatinum:
                        PlatinumCard(showModal: $showModal)
                    
                    case .amoreGold:
                        GoldCard(showModal: $showModal)
                        
                    }
                    
                }
            }
        }
    }
}


struct UserProfile_Previews: PreviewProvider {
    
    static var previews: some View {
        
        SuperLikeCard(showModal: Binding.constant(false))
        
        //        UserProfile()
        //            .environmentObject(ProfileViewModel())
        //            .environmentObject(PhotoModel())
    }
}
