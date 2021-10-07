//
//  AboutView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct AboutView: View {
    
    var profileBio: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("About")
                .font(.BoardingTitle2)
            
            Text(profileBio)
                .font(.subheadline)
        }
    }
}
