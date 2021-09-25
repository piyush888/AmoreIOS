//
//  NumberCode.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/24/21.
//

import SwiftUI
import Combine

struct NumberCode: View {
    
    var phoneNumber: String
    @State var pin: String = ""
    
    var body: some View {
        
        VStack {
            
            VStack(alignment: .leading) {
                Text("Type the verification code we've sent ")
                    .font(.BoardingTitle)
                    .padding(.bottom, 10)
                
                Text("\(phoneNumber)")
                    .foregroundColor(.pink)
            }
            .padding(.top, 100)
            
            
            VStack(alignment: .center) {
                
//                TextField("0000", text: $pin)
//                    .keyboardType(.numberPad)
//                    .font(Font.custom("Sk-Modernist-Bold", size: 40))
//                    .onReceive(Just(pin)) { newValue in
//                        let filtered = newValue.filter { "0123456789".contains($0) }
//                        if filtered != newValue {
//                            self.pin = filtered
//                    }
//                }
//
                OTPKeyCode()
            }
            .padding(.top, 130)
            
            Spacer()
        }
        .padding(.horizontal,80)
        
    }
}


struct NumberCode_Previews: PreviewProvider {
    static var previews: some View {
        NumberCode(phoneNumber: "5516971888")
    }
}
