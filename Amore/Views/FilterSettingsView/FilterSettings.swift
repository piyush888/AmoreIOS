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
    
    @State var minAgeFilter : Int = 21
    @State var maxAgeFilter : Int = 28
    
    var body: some View {
        
        NavigationView {
            
            VStack(alignment: .leading) {
                
                Text("Filters")
                    .foregroundColor(.orange)
                    
                //
                GenderSettings(genderPreference: $filterAndLocationModel.filterAndLocationData.genderPreference.bound)
                
                
                AgeSettings(minAgeFilter:$minAgeFilter,
                            maxAgeFilter:$maxAgeFilter)
                
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
