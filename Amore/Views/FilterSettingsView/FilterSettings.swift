//
//  FilterSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct FilterSettings: View {
    
    // User Filter Settings
    
    // Show me preference
    @State var genderPreference = "Man"
    
    // Age perference
    @State var minAge : CGFloat = 20
    @State var maxAge : CGFloat = 30
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Spacer()
            
            Text("Filters")
                .foregroundColor(.orange)
            
            //
            GenderSettings(genderPreference: $genderPreference)
            
            AgeSettings(minAge:$minAge,
                        maxAge: $maxAge)
            
            Spacer()
         
        }
        .padding(.top,20)
        .padding(.horizontal)
        
    }
}

struct FilterSettings_Previews: PreviewProvider {
    static var previews: some View {
        FilterSettings()
    }
}
