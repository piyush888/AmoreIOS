//
//  CardPassions.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI

struct CardPassions: View {
    
    var passions: [String] = [""]
    @State private var passionsCombinedString = ""
    
    
    func combineString() {
        passionsCombinedString = passions.joined(separator: ", ")
    }
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Interests")
                .font(.BoardingTitle2)
            
            Text(passionsCombinedString)
                .font(.subheadline)
        }
        .onAppear {
            combineString()
        }
    }
}

struct PassionsCombinedString_Previews: PreviewProvider {
    static var previews: some View {
        CardPassions(passions: ["Hello","World"])
    }
}
