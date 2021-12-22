//
//  TextSlider.swift
//  Amore
//
//  Created by Kshitiz Sharma on 12/18/21.
//

import SwiftUI

struct SafetyIconWithMessage:Identifiable {

    var id: Int
    var iconName: String
    var safetyStatement: String
    var colorScheme: [Color]
    
}


struct TextSlider: View {
    
    @State var safetyMessages: [SafetyIconWithMessage] = [SafetyIconWithMessage(id:1,
                                                                                iconName:"shield.fill",
                                                                                safetyStatement:"Keep your community safe",
                                                                                colorScheme: [Color.blue, Color.white]),
                                                        SafetyIconWithMessage(id:2,
                                                                              iconName:"eye.circle.fill",
                                                                              safetyStatement:"See something, Say something",
                                                                              colorScheme: [Color.yellow]),
                                                          SafetyIconWithMessage(id:3,
                                                                                iconName:"exclamationmark.octagon.fill",
                                                                                safetyStatement:"Report suspicious accounts and activity",
                                                                                    colorScheme: [Color.green])]
    @State private var selectedIndexCount = 1
    @State private var selectedTabIndex = 1
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()

    var body: some View {
        TabView(selection: $selectedTabIndex) {
            ForEach(safetyMessages) {value in
                VStack {
                    
                    LinearGradient(
                        gradient: Gradient(colors: value.colorScheme),
                        startPoint: .leading,
                        endPoint: .trailing)
                        .frame(width:60, height:65)
                        .mask(Image(systemName: value.iconName)
                                .font(.system(size:55)))
                        
                    Text(value.safetyStatement)
                        .foregroundColor(Color.gray)
                        .font(.subheadline)
                        .italic()
                
                }.tag(value.id)
            }
        }
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .always))
        .onReceive(timer) { _ in
                selectedIndexCount = selectedIndexCount+1
                selectedTabIndex = selectedIndexCount % 4
        }
        .animation(.easeInOut) // 2
        .transition(.slide) // 3
        
    }
}

struct TextSlider_Previews: PreviewProvider {
    static var previews: some View {
        TextSlider()
    }
}
