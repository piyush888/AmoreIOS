//
//  LocationHomeView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/1/21.
//

import SwiftUI

struct LocationHomeView: View {
    
//    @EnvironmentObject var locationModel: LocationModel
    @EnvironmentObject var profileModel: ProfileViewModel
    
    var body: some View {
        
        VStack {
            
            // When location is Not determined - Ideally this case shouldn't happen
            // It's an issue if this case happens - KTZ
            if profileModel.authorizationStatus == .notDetermined {
                Text("Location Not Determined")
                    .onAppear {
                        profileModel.requestPermission()
                    }
            }
            
            // This case will also never happen. This is being checked in the ContentView, so if that condition is True it will never fall back to this condition. Infact this condition shouldn't exists here either. But I won't delete it rn. 08.15.2022 - KTZ
            // When the location access is given by the user
            else if profileModel.authorizationStatus == .authorizedAlways || profileModel.authorizationStatus == .authorizedWhenInUse {
                // Show home view
                Text("Location Granted")
                Spacer()
                Button{
                    // Use this function whenever you want to update the location data
                    // It can also be called as a state variable when a view loads
                    profileModel.getLocationOnce()
                } label : {
                    ZStack{
                        Rectangle()
                            .frame(height:45)
                            .cornerRadius(10.0)
                            .foregroundColor(.accentColor)
                        
                        Text("Update Location")
                            .foregroundColor(.white)
                    }
                }.padding(.bottom, 10)
            }
            // When location access is denied by the user
            else {
                LocationDenied()
                    .environmentObject(profileModel)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LocationHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LocationHomeView()
            .environmentObject(ProfileViewModel())
    }
}
