//
//  RadiusFilter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/29/21.
//

import SwiftUI


struct RadiusFilter: View {
    
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var filterModel: FilterModel
    
    
    var body: some View {
        
            NavigationLink(
                destination: DistanceSlider(radiusDistance:$filterModel.filterData.radiusDistance.boundCGFloat)
                                    .environmentObject(cardProfileModel),
              label: {
                      FilterCommonContainer(filterName:"Radius",
                                            filteredValue:"Modify")
              })
        }
}

struct DistanceSlider: View {
    
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @State private var appearance: Float = 4
    @Binding var radiusDistance: CGFloat
    @State private var isEditing = false
    let distanceOptions:[CGFloat] = [5,20,50,100,300,500,750,1000,5000]
    let countryCode = NSLocale.current.regionCode
    
    var body: some View {
        VStack {
           Slider(
               value: $appearance,
               in: 0...8,
               step: 1,
               onEditingChanged: { editing in
                   radiusDistance = distanceOptions[Int(appearance)]
                   cardProfileModel.filterRadius = radiusDistance
               }
           ).onAppear {
               appearance = Float(distanceOptions.firstIndex(of: radiusDistance) ?? 4)
           }
            
            Text("\(String(format: "Show profile in radius: %.0f", radiusDistance)) \(countryCode == "US" ? "Miles" : "Km")")
                .foregroundColor(Color.gray)
        
        
       }
        .padding(.horizontal,40)
    }
}


