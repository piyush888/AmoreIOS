//
//  PlayGround.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/19/21.
//

import SwiftUI

struct PlayGround: View {
    var bgColor: Color
    @State private var isPressed: Bool = false
       
    var body: some View {
        VStack {
                Text("Hello World")
        }
    }
}

struct PlayGround_Previews: PreviewProvider {
    static var previews: some View {
        PlayGround(bgColor: Color.white)
    }
}


    
