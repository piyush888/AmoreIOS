//
//  ProfileBioHeadline.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/14/21.
//

import SwiftUI

struct ProfileBioHeadline: View {
    
    @State var description: String
    @State var bgColor: Color
    @State var headlineText: String
    
    var body: some View {
        
            VStack(alignment: .leading) {
                Text(headlineText)
                  .bold()
                  .padding()
                    
                Text(description)
                    .font(.subheadline)
                    .padding(.horizontal)
                    .padding(.bottom)
                    
            }
            .frame(
              minWidth: 0,
              maxWidth: .infinity,
              minHeight: 0,
              maxHeight: .infinity,
              alignment: .topLeading
            )
            .background(bgColor)
            .cornerRadius(15)
            .onAppear {
                if self.description == "" {
                    self.description = "No bio provided"
                }
            }
        
        
    }
}

struct ProfileBioHeadline_Previews: PreviewProvider {
    static var previews: some View {
        
        ProfileBioHeadline(description: "My name is Kshitiz Sharma, I am the founder of Drone AI. I started building drone software as a hobby & added AI features to it & opened it to the general public."
                   ,bgColor: Color.yellow,
                   headlineText:"Bio")
            .padding()
            
    }
}
