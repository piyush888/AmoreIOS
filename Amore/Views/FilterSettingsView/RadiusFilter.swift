//
//  RadiusFilter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/29/21.
//

import SwiftUI


struct RadiusFilter: View {
    
    @Binding var radiusDistance: CGFloat
    
    var body: some View {
        
            NavigationLink(
              destination: DistanceSlider(radiusDistance:$radiusDistance),
              label: {
                  ZStack{
                  CommonContainer()
                  HStack {
                      
                      Text("Amore Radius")
                          .font(.subheadline)
                          .foregroundColor(Color.black)
                      
                      Spacer()
                      
                      Text("\(String(format: "%.0f", radiusDistance)) km")
                  }
                  .padding(.horizontal,20)
              }
          })
        
    }
}

struct DistanceSlider: View {
    
    @State private var appearance: Float = 4
    @Binding var radiusDistance: CGFloat
    @State private var isEditing = false
    let distanceOptions:[CGFloat] = [5,20,50,100,300,500,750,1000,5000]
    
    var body: some View {
        VStack {
           Slider(
               value: $appearance,
               in: 1...9,
               step: 1,
               onEditingChanged: { editing in
                   radiusDistance = distanceOptions[Int(appearance)-1]
               }
           )
            Text("\(String(format: "Amore Radius: %.0f", radiusDistance)) km")
                .foregroundColor(Color.gray)
       }
        .padding(.horizontal,40)
    }
}


