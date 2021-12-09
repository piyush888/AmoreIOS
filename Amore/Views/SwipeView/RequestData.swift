//
//  RequestData.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/6/21.
//

import SwiftUI

struct RequestData: View {
    
    @State var property: String
    @State private var showingAlert = false
    
    var body: some View {
        
        HStack {
            Button {
                // Send the request to provide data
                print("Send the user notification to provide data to unlock profile who requested the data")
            } label: {
                Text("Request \(property)")
                    .font(.caption2)
            }
            
            Button {
                showingAlert = true
            } label: {
                Image(systemName: "info.circle")
                    .font(.caption2)
            }
                
        }
        .alert(isPresented: $showingAlert) {
           Alert(
               title: Text("Requesting Info"),
               message: Text("If the user accepts your request to provide data, you will be automatically matched with that user.")
           )
        }
        
    }
}

struct RequestData_Previews: PreviewProvider {
    static var previews: some View {
        RequestData(property:"Headline")
    }
}
