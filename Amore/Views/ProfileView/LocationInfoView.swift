//
//  LocationInfoView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct LocationInfoView: View {
    
    var profileCity: String
    var profileState: String
    var profileCountry: String
    var profileDistanceFromUser: String
    
    
    var body: some View {
        // City of the profile being watched
        VStack(alignment: .leading) {
            Text("Location")
                .font(.BoardingTitle2)
            
            Text("\(profileCity), \(profileState) \(profileCountry)")
                .font(.subheadline)
        }
        
        Spacer()
        
        // Distance from current User
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("profile-light-pink"))
                .frame(width: 80, height: 30, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                
            
            HStack {
                Image(systemName: "mappin.and.ellipse")
                    .resizable()
                    .frame(width:20, height:20)
                    .foregroundColor(.pink)
                
                Text("\(profileDistanceFromUser) km")
                    .foregroundColor(.pink)
            }
        }
    }
}
