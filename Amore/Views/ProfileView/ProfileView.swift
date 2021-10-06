//
//  ProfileView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/5/21.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        ScrollView {
            VStack {
                
                ZStack {
                    // Main User Image
                    Image("image1")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                    
                    HStack {
                        
                    }
                }
                
                HStack {
                    
                    VStack {
                        Text("Jessica Parker, 23")
                            .font(.BoardingTitle)
                        
                        Text("Professional Model")
                    }
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        
                    }
                    
                }
                
            }
        }
        .ignoresSafeArea(.all)
        
       
        
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
