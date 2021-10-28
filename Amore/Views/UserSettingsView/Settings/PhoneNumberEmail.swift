//
//  PhoneNumberEmail.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/28/21.
//

import SwiftUI

struct PhoneNumberEmail: View {
    
    @State var width: CGFloat = 0.0
    
    var body: some View {
        ZStack {
            Color(red: 0.80, green: 1.0, blue: 1.0)
                .overlay(
                    VStack(spacing: 20) {
                        HStack {
                            Text("Phone Number")
                                .font(.subheadline)
                            Spacer()
                            Text("551-697-1888")
                                .font(.subheadline)
                        }
                        .padding([.horizontal,.top],10)
                        
                        
                        Divider()
                        
                        HStack {
                            Text("Email")
                                .font(.subheadline)
                            Spacer()
                            Text("kshitizsharmav@gmail.com")
                                .font(.subheadline)
                                .foregroundColor(Color.black)
                        }
                        .padding([.horizontal,.bottom],10)
                        
                    }
                    .cornerRadius(10)
                    .background(Color.white)
                    .padding(.horizontal,20)
                )
        }
        .cornerRadius(15)
        .frame(width: width, height: 140)
        
    }
}

struct PhoneNumberEmail_Previews: PreviewProvider {
    static var previews: some View {
        PhoneNumberEmail()
    }
}
