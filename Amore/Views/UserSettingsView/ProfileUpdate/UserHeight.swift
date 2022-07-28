//
//  UserHeight.swift
//  Amore
//
//  Created by Kshitiz Sharma on 7/27/22.
//

import SwiftUI



import SwiftUI

struct UserHeight: View {
    
    @Binding var height: Double
    
    var body: some View {
        
        Slider(
               value: $height,
               in: 120...220,
               step: 1
        ) {
            Text("Does nothing")
        }
        minimumValueLabel: {
        //                           Text("120 cm")
           Image(systemName: "minus")
                
        } maximumValueLabel: {
        //                           Text("220 cm")
           Image(systemName: "plus")
        }
        .accentColor(Color.green)

        HStack {
            Text(String(format: "%.1f",height) + " cm")
            Spacer()
            Text(String(format: "%.1f",height*0.0328) + " ft")
            Spacer()
            Text(String(format: "%.1f",height*0.394) + " inch")
        }
        .foregroundColor(Color.gray)

        
    }
}

struct UserHeight_Previews: PreviewProvider {
    static var previews: some View {
        UserHeight(height:Binding.constant(150))
    }
}


