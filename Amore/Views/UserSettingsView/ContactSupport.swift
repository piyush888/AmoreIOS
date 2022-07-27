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
            // TODO - Get the official email address and pop a email to the support team
        } label : {
            HStack {
                Image(systemName: "envelope.fill")
                Text("Conact Support")
            }
        }
    }
}

struct ContactSupport_Previews: PreviewProvider {
    static var previews: some View {
        ContactSupport()
    }
}
