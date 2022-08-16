//
//  LocationView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/30/21.
//

import SwiftUI


struct LocationView: View {
    
    // LocationModel is an observable object
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                Image(systemName: "location.circle.fill")
                                    .resizable()
                                    .frame(width:80, height:80)
                                    .foregroundColor(.accentColor)
                                    .padding(.bottom, 20)
                                    .padding(.top, 20)
                
                Text("Enable Location")
                    .font(.title2)
                Text("Please enable your location in order to user Amore")
                    .font(.caption)
                    .multilineTextAlignment(.center)
                                    
                Spacer()

                
                NavigationLink(
                    destination: LocationHomeView()
//                        .environmentObject(locationModel)
                        .environmentObject(profileModel),
                    // Will only go to next view when the user either "accepts" or "denies" location
                    // If the user gives location "ones" that will be useful for 1 time only
                    // The next time location when you open app again it will be ".notDetermined"
                    isActive: .constant(profileModel.authorizationStatus != .notDetermined),
                    label: {
                        // Continue to next view
                        Button{
                            // Call this to give a user pop-up
                            profileModel.requestPermission()
                            profileModel.getLocationOnce()
                        } label : {
                            ContinueButtonDesign(buttonText:"Continue")
                        }.padding(.bottom, 10)
                    })
                
            }
            .navigationBarHidden(true)
        }.padding(20)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
            .environmentObject(ProfileViewModel())
    }
}
