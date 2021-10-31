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
    @Binding var settingsDone: Bool
    @State var popUpCardSelection: PopUpCards = .amoreGold
    @State var showModal = false
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack {
                
                // Done will take back to Profile View
                HStack {
                    Text("Settings")
                        .font(.title)
                    
                    Spacer()
                    
                    Button {
                        // Take Back to Profile View
                        settingsDone = false
                    } label: {
                        Text("Done")
                            .font(.title2)
                            .foregroundColor(.pink)
                    }
                    
                }
                
                // Amore Platinum
                AmorePlatinum(width:geometry.size.width,
                              popUpCardSelection:$popUpCardSelection,
                              showModal:$showModal)
                
                // Amore Gold
                AmoreGold(width:geometry.size.width,
                          popUpCardSelection:$popUpCardSelection,
                          showModal:$showModal)
                
                // Super Like and Boost Count and Buy
                SuperLikeBoost(width:geometry.size.width/2)
                
                // Section
                /// Phone Number
                /// Email Address
                PhoneNumberEmail(width:geometry.size.width)
                
                // Section
                /// Help & Support, Legal and Privacy Policy
                ContactCommunityLegal()
                
                
                Spacer()
                
                
                // Log Out
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
                            .frame(width:geometry.size.width, height:40)
                            .shadow(color: Color.black, radius: 1, x: 0.5, y: 0.5)
                        
                        Text("Log Out")
                            .foregroundColor(Color.pink)
                    }
                    
                }
                
                
                
                
            }
            .navigationBarHidden(true)
            
        }
        .padding(20)
    }
}

struct UserSettingView_Previews: PreviewProvider {
    static var previews: some View {
        UserSettingView(settingsDone:Binding.constant(true))
    }
}
