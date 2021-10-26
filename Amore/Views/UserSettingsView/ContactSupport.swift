//
//  ContactSupport.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI

struct ContactSupport: View {
    
    var body: some View {
        
        Button{
            // TODO
        } label : {
            ZStack{
                RoundedRectangle(cornerRadius: 5.0)
                    .stroke(Color.pink, lineWidth: 1)
                    .frame(height:45)
                    
                Text("Conact Support")
                    .foregroundColor(.pink)
                    .bold()
                    .font(.BoardingButton)
            }
        }.padding(.bottom, 10)
        
    }
}

struct ContactSupport_Previews: PreviewProvider {
    static var previews: some View {
        ContactSupport()
    }
}
