//
//  LocationHomeView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/1/21.
//

import SwiftUI

struct LocationHomeView: View {
    
    @EnvironmentObject var location: LocationModel
    
    var body: some View {
        
        VStack {
            
            // When location is Not determined - Ideally this case shouldn't happen
            if location.authorizationState == .notDetermined {
                Text("Location Not Determined")
            }
            // When the location access is given by the user
            else if location.authorizationState == .authorizedAlways || location.authorizationState == .authorizedWhenInUse{
                // Show home view
                Text("Location Granted")
                
                Spacer()
                
                Button{
                    // Use this function whenever you want to update the location data
                    // It can also be called as a state variable when a view loads
                    location.requestLocationAgain()
                } label : {
                    ZStack{
                        Rectangle()
                            .frame(height:45)
                            .cornerRadius(5.0)
                            .foregroundColor(.pink)
                        
                        Text("Update Location")
                            .foregroundColor(.white)
                            .bold()
                            .font(.BoardingButton)
                    }
                }.padding(.bottom, 10)
                
            }
            // When location access is denied by the user
            else {
                LocationDenied()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

struct LocationHomeView_Previews: PreviewProvider {
    static var previews: some View {
        LocationHomeView()
    }
}
