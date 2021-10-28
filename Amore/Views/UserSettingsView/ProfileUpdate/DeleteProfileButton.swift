//
//  DeleteProfileButton.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/25/21.
//

import SwiftUI

struct DeleteProfileButton: View {
    
    var body: some View {
        
        Button{
            // TODO
        } label : {
            ZStack{
                Rectangle()
                    .frame(height:45)
                    .cornerRadius(5.0)
                    .foregroundColor(.pink)
                
                Text("Delete Account")
                    .foregroundColor(.white)
                    .bold()
                    .font(.BoardingButton)
            }
        }.padding(.bottom, 10)
        
    }
}

struct DeleteProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileButton()
    }
}
