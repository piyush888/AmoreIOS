//
//  UserSettings.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI
import FirebaseAuth

struct UserSettings: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        
        VStack {
            Button {
                try! Auth.auth().signOut()
                logStatus = false
            } label: {
                Text("Log Out")
            }
            Spacer()
        }
        
    }
}

struct UserSettings_Previews: PreviewProvider {
    
    static var previews: some View {
        UserSettings()
    }
}
