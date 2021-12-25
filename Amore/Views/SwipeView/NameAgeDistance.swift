//
//  NameAgeDistance.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct NameAgeDistance: View {
    
    @State var firstName: String
    @State var lastName: String
    @State var age: Int
    @Binding var profileDistanceFromUser: Double
    @State var geometry: GeometryProxy
    
    var body: some View {
        
        
        ZStack{
            
            Rectangle()
                .fill(LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.black]),
                    startPoint: .top,
                    endPoint: .bottom)
                )
                .frame(width:geometry.size.width-10, height:  geometry.size.height/10)
                .opacity(0.8)
                .cornerRadius(20)
            
            HStack {
                
                VStack(alignment:.leading, spacing:0)  {
                    
                    HStack {
                        Text("\(firstName)")
                            .font(.title)
                            .bold()
                        
                        Text("\(age)")
                            .font(.title3)
                    }
                    
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width:20, height:20)
                            
                        Text(String(format: "%.1f",profileDistanceFromUser) + " km")
                            .font(.headline)
                        
                    }
                    
                }
                .padding(.horizontal,20)
                .foregroundColor(.white)
                Spacer()
            }
            
            
        }
        .padding(.vertical,5)
        
    }
}
    

struct NameAgeDistance_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader { geometry in
            NameAgeDistance(firstName: "Hello",
                            lastName: "World",
                            age: 24,
                            profileDistanceFromUser: Binding.constant(17),
                            geometry: geometry)
        }
    }
}
