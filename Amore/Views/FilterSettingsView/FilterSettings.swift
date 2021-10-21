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
    
    // Age perference - Scales are according to screen
    // 66.66(Scale on screen) / 368.0 (Max size of screen self.MaxPossibleAg) = 18
    // 215.66(Scale on screen) / 368.0 (Max size of screen self.MaxPossibleAg) = 61
    @State var scaleMinAge : CGFloat = 66.66
    @State var scaleMaxAge : CGFloat = 215.66
    @State var realMinAge : String = String(format : "%.0f",(66.66 / (UIScreen.main.bounds.width - 60) * 100))
    @State var realMaxAge : String = String(format : "%.0f",(215.66 / (UIScreen.main.bounds.width - 60) * 100))
    
    
    var body: some View {
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Spacer()
                
                Text("Filters")
                    .foregroundColor(.orange)
                
                //
                GenderSettings(genderPreference: $genderPreference)
                
                AgeSettings(scaleMinAge:$scaleMinAge,
                            scaleMaxAge: $scaleMaxAge,
                            realMinAge: $realMinAge,
                            realMaxAge: $realMaxAge)
                
                Spacer()
             
            }
            .padding(.top,20)
            .padding(.horizontal)
        }
    }
}

struct FilterSettings_Previews: PreviewProvider {
    static var previews: some View {
        FilterSettings()
    }
}
