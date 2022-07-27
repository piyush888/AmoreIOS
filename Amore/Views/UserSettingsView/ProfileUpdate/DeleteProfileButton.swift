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
            HStack {
                Image(systemName: "trash.fill")
                Text("Delete Account")
            }
            .foregroundColor(.pink)
        }
        .padding(.bottom, 10)
        
    }
}

struct DeleteProfileButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteProfileButton()
    }
}
