//
//  ProfileBioHeadline.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ProfileBioHeadline: View {
    
    @State var description: String
    @State var headlineText: String
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        if self.description != "" {
            VStack(alignment: .leading) {
                Spacer()
                Text(headlineText)
                  .bold()
                  .padding()
                    
                Text(description)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.bottom)
                Spacer()
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .background(colorScheme == .dark ? Color(hex: 0x24244A): Color(hex: 0xe8f4f8))
            .cornerRadius(15)
        }
    }
}

struct ProfileBioHeadline_Previews: PreviewProvider {
    static var previews: some View {
        
        ProfileBioHeadline(description: "My name is Kshitiz Sharma, I am the founder of Drone AI. I started building drone software as a hobby & added AI features to it & opened it to the general public.",
                   headlineText:"Bio")
            .padding()
        
        // No view will be returned
        ProfileBioHeadline(description: "",
                   headlineText:"Bio")
            .padding()
        
        // No view will be returned
        ProfileBioHeadline(description: "Hey How are you",
                   headlineText:"Bio")
            .padding()
    }
}
