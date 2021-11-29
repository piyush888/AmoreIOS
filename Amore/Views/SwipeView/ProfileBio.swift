//
//  ProfileBio.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ProfileBio: View {
    
    @State var description: String
    
    var body: some View {
        
        VStack(alignment: .leading) {
              Text(description)
                .font(.subheadline)
                .padding()
              Spacer()
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .background(Color(hex: 0xFFFFE0))
    }
}

struct ProfileBio_Previews: PreviewProvider {
    static var previews: some View {
        
        ProfileBio(description: "My name is Kshitiz Sharma, I am the founder of Drone AI. I started building drone software as a hobby & added AI features to it & opened it to the general public.")
            .padding()
            
    }
}
