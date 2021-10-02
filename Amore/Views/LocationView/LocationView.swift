//
//  LocationView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/30/21.
//

import SwiftUI


struct LocationView: View {
    
    // LocationModel is an observable object
    @EnvironmentObject var location: LocationModel
    
    var body: some View {
        
        NavigationView {
            
            VStack {
                
                Spacer()
                
                Image(systemName: "location.fill.viewfinder")
                    .resizable()
                    .frame(width:100, height:100)
                    .foregroundColor(.pink)
                    .padding(.bottom, 20)
                
                Text("Enable Location")
                    .font(.BoardingTitle)
                Text("You'll need to enable your location in order to user Amore")
                    .font(.BoardingSubHeading)
                    .padding(.horizontal,60)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 400)
                
                Spacer()
                
                
                NavigationLink(
                    destination: LocationHomeView(),
                    // Will only go to next view when the user either "accepts" or "denies" location
                    // If the user gives location "ones" that will be useful for 1 time only
                    // The next time location when you open app again it will be ".notDetermined"
                    isActive: .constant(location.authorizationState != .notDetermined),
                    label: {
                        // Continue to next view
                        Button{
                            // Call this to give a user pop-up
                            location.getLocation()
                        } label : {
                            ZStack{
                                Rectangle()
                                    .frame(height:45)
                                    .cornerRadius(5.0)
                                    .foregroundColor(.pink)
                                
                                Text("Allow Location")
                                    .foregroundColor(.white)
                                    .bold()
                                    .font(.BoardingButton)
                            }
                        }.padding(.bottom, 10)
                    })
                
            }
        }.padding(20)
    }
}

struct LocationView_Previews: PreviewProvider {
    static var previews: some View {
        LocationView()
    }
}
