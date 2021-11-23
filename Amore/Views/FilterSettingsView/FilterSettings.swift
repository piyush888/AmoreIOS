//
//  FilterSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

struct FilterSettings: View {
    
    // User Filter Settings
    @EnvironmentObject var filterAndLocationModel: FilterAndLocationModel
    
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
                
                Text("Filters")
                    .foregroundColor(.orange)
                    
                //
                GenderSettings(genderPreference: $filterAndLocationModel.filterAndLocationData.genderPreference.bound)
                
                AgeSettings(scaleMinAge:$scaleMinAge,
                            scaleMaxAge: $scaleMaxAge,
                            realMinAge: $realMinAge,
                            realMaxAge: $realMaxAge)
                
                
                ReligionFilter(religionPreference: $filterAndLocationModel.filterAndLocationData.religionPreference.boundStringArray)
                CommunityFilter(communityPreference: $filterAndLocationModel.filterAndLocationData.communityPreference.boundStringArray)
                CareerFilter(careerPreference: $filterAndLocationModel.filterAndLocationData.careerPreference.boundStringArray)
                EducationFilter(educationPreference: $filterAndLocationModel.filterAndLocationData.educationPreference.bound)
                RaisedInFilter(countryPreference: $filterAndLocationModel.filterAndLocationData.countryPreference.bound)
                
                
                
                Spacer()
             
            }
            .padding(.top,10)
            .padding(.horizontal)
            .navigationBarHidden(true)
        }
    }
}

struct FilterSettings_Previews: PreviewProvider {
    static var previews: some View {
        FilterSettings()
    }
}
