//
//  UserSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI
import FirebaseAuth

struct UserSettings: View {
    
    @Binding var loggedIn: Bool

    var body: some View {
        
        VStack {
            Button {
                try! Auth.auth().signOut()
                loggedIn = false
            } label: {
                Text("Log Out")
            }
            Spacer()
        }
        
    }
}

struct UserSettings_Previews: PreviewProvider {
    
    @State var loggedIn: Bool = false
    
    static var previews: some View {
        UserSettings(loggedIn: Binding.constant(true))
    }
}
