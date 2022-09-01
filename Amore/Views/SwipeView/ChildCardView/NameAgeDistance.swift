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
                    gradient: Gradient(colors: [Color.black, Color.clear, Color.clear]),
                    startPoint:.leading,
                    endPoint: .trailing)
                )
                .frame(width:geometry.size.width, height:  geometry.size.height/10)
                .opacity(0.3)
                
            HStack {
                VStack(alignment:.leading, spacing:0)  {
                    
                    HStack {
                        Text("\(firstName)")
                            .font(.title2)
                            .bold()
                        
                        Text("\(lastName),")
                            .font(.title3)
                            
                    
                        Text("\(age)")
                            .font(.title3)
                    }
                    
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                            .resizable()
                            .frame(width:16, height:16)
                            
                        Text(String(format: "%.1f",profileDistanceFromUser) + " km")
                            .font(.headline)
                    }
                    
                    
                }
                .padding(.horizontal,30)
                .foregroundColor(.white)
                Spacer()
            }
        }
        
        
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