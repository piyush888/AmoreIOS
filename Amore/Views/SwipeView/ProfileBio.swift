//
//  ProfileBio.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ProfileBio: View {
    
    @State var description: String
    @State var boxHeight: CGFloat
    
    var body: some View {
        
        ZStack{
            RoundedRectangle(cornerRadius: 20.0)
                .foregroundColor(Color.yellow)
                .frame(height: boxHeight)
                .opacity(0.1)
                
            VStack(alignment: .leading) {
                Text(description)
                    .font(.subheadline)
            }
            .padding(15)
        }
        .padding(10)
        .foregroundColor(Color.black)
        
    }
}

struct ProfileBio_Previews: PreviewProvider {
    static var previews: some View {
        
        GeometryReader  {geometry in
            ProfileBio(description: "My name is Kshitiz Sharma, I am the founder of Drone AI. I started building drone software as a hobby & added AI features to it & opened it to the general public.",
                       boxHeight:geometry.size.height/7
            )
        }
    }
}
