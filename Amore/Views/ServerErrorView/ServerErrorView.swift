//
//  ServerErrorView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 11/28/21.
//

import SwiftUI
import FirebaseAuth

struct ServerErrorView: View {
    
    @AppStorage("log_Status") var logStatus = false
    
    let email = "support@aidronesoftware.com"
    
    var body: some View {
        
        GeometryReader { geometry in
            
            HStack(alignment: .center) {
                Spacer()
                VStack {
                    Spacer()
                        Image(systemName: "exclamationmark.icloud.fill")
                            .font(.system(size: 60))
                            .frame(width: 60)
                            .padding()
                        
                        Text("Connection or Server Error. Please Log out and try again. We are looking into it")
                        .multilineTextAlignment(.center)
                        
                    
                        Button{
                            if let url = URL(string: "mailto:\(email)") {
                              if #available(iOS 10.0, *) {
                                UIApplication.shared.open(url)
                              } else {
                                UIApplication.shared.openURL(url)
                              }
                            }
                        } label : {
                            ZStack {
                                Capsule()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                    )
                                    .frame(width:geometry.size.width*0.50, height:40)
                                    .shadow(color: Color.black, radius: 1, x: 0.5, y: 0.5)
                                Text("Let us know about issue")
                                    .foregroundColor(Color.white)
                            }
                        }
                    
                        Button{
                            try! Auth.auth().signOut()
                            logStatus = false
                        } label : {
                            ZStack {
                                Capsule()
                                    .fill(LinearGradient(
                                        gradient: Gradient(colors: [Color.white]),
                                        startPoint: .leading,
                                        endPoint: .trailing)
                                    )
                                    .frame(width:geometry.size.width*0.50, height:40)
                                    .shadow(color: Color.black, radius: 1, x: 0.5, y: 0.5)
                                Text("Log Out")
                                    .foregroundColor(Color.pink)
                            }
                        }
                    Spacer()
                    
                }.foregroundColor(.gray)
                Spacer()
            }
        }
    }
}

struct ServerErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ServerErrorView()
    }
}
