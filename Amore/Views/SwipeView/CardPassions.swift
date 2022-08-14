//
//  CardPassions.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI
import WrappingStack

struct CardPassions: View {
    @Environment(\.colorScheme) var colorScheme
    var passions: [String] = [""]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            
            Text("Passions")
             .bold()
            
            WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 5, verticalSpacing: 5) {
                ForEach(passions, id: \.self) { passion in
                    
                    Text("#\(passion)")
                       .font(.subheadline)
                       .foregroundColor(Color.white)
                       .padding(10)
                       .background(
                           Rectangle()
                               .stroke(Color.blue)
                               .background(Color.blue)
                               .cornerRadius(10.0)
                       )
                }
            }
        }
        
    }
}

struct CardPassions_Previews: PreviewProvider {
    static var previews: some View {
        CardPassions(passions: ["Photography","Jumping","Writting","Running","Air","Hellophot"])
    }
}
