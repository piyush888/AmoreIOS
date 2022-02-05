//
//  ChannelView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI
import FirebaseMessaging

struct ChannelView: View {
    
    var body: some View {
        
        VStack {
            Spacer()
            Text("This is message view")
            Spacer()
            
            Button {
                let token = Messaging.messaging().fcmToken
                print("FCM token: \(token ?? "")")
                // [END log_fcm_reg_token]
                
                // [START log_iid_reg_token]
                Messaging.messaging().token { token, error in
                  if let error = error {
                    print("Error fetching remote FCM registration token: \(error)")
                  } else if let token = token {
                    print("Remote instance ID token: \(token)")
                  }
                }
            } label: {
                Text("Print FCM token")
            }
            
        }
        
    }
}

struct ChannelView_Previews: PreviewProvider {
    static var previews: some View {
        ChannelView()
    }
}
