//
//  DiscoveryDisabled.swift
//  Amore
//
//  Created by Piyush Garg on 17/08/22.
//

import SwiftUI
import Firebase

struct DiscoveryDisabled: View {
    
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        VStack {
            
            Spacer()
            
            Image(systemName: "heart.slash.circle.fill")
                                .resizable()
                                .frame(width:80, height:80)
                                .foregroundColor(.accentColor)
                                .padding(.bottom, 20)
                                .padding(.top, 20)
            
            Text("You're no longer discoverable")
                .font(.title2)
                .padding(.bottom)
            Text("Enable discovery to get back in the game. Profiles liked by you may continue to see your profile and match with you, but others won't be able to see your profile.")
                .font(.caption)
                .multilineTextAlignment(.center)
                                
            Spacer()

            // Enable Discovery
            Button{
                DispatchQueue.main.async {
                    profileModel.editUserProfile.discoveryStatus = true
                    profileModel.updateUserProfile(profileId: Auth.auth().currentUser?.uid)
                }
            } label : {
                ContinueButtonDesign(buttonText:"Enable Discovery")
            }
            .padding()
            
            Spacer()
            
        }
        .padding()
    }
}

struct DiscoveryDisabled_Previews: PreviewProvider {
    static var previews: some View {
        DiscoveryDisabled()
            .environmentObject(ProfileViewModel())
    }
}
