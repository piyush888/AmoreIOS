//
//  CardPassions.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/6/21.
//

import SwiftUI
import WrappingStack

struct CardPassions: View {
    
    var passions: [String] = [""]
    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Text("Passions")
                    .font(.BoardingTitle2)
                Spacer()
            }
            
            WrappingHStack(id: \.self, alignment: .leading, horizontalSpacing: 5, verticalSpacing: 5) {
                ForEach(passions, id: \.self) { passion in
                    
                    Text("#\(passion)")
                        .font(.subheadline)
                       .padding(10)
                       .background(
                           Rectangle()
                               .stroke(Color.yellow)
                               .background(Color.yellow)
                               .cornerRadius(10.0)
                               .opacity(0.1)
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
