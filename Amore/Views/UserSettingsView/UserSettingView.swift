//
//  UserSettingView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/22/21.
//

import SwiftUI
import FirebaseAuth

struct UserSettingView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    var body: some View {
        
        VStack {
            Text("This is your settings")
            
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

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView()
    }
}
