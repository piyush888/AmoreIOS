//
//  ControlCenter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/10/21.
//

import SwiftUI


struct TabItem: Identifiable {
    var id = UUID()
    var text: String
    var icon: String
    var tab: ViewTypes
    var color: Color
}

var tabItems = [
    TabItem(text: "Messages", icon: "text.bubble.fill", tab: .messagingView, color: Color(hex:0x008080)),
    TabItem(text: "History", icon: "sparkles", tab: .likesTopPicksView, color: .blue),
    TabItem(text: "Swipe", icon: "bonjour", tab: .swipeView, color: .red),
//    TabItem(text: "Filter", icon: "slider.vertical.3", tab: .filterSettingsView, color: .purple),
    TabItem(text: "Profile", icon: "person.fill", tab: .userSettingsView, color: .pink)
]

struct ControlCenter: View {
    
    @Binding var currentPage: ViewTypes
    
    var body: some View {
            
            // Fallback on earlier versions
            HStack {
                tabButtonList
            }
            .padding(.horizontal, 8)
            .padding(.top, 14)
            .padding(.bottom, 35)
            .background(
                RoundedRectangle(cornerRadius: 0, style: .continuous)
                    .fill(Color(hex:0xFF6EE0))
                    .strokeStyle(cornerRadius:0)
                    .opacity(0.2)
            )
            .strokeStyle(cornerRadius:34)
            
    }
    
    var tabButtonList: some View {
        ForEach(tabItems) { item in
            TabButton(systemImage: item.icon,
                      tabViewType: item.tab,
                      buttonColor: item.color,
                      currentPage: $currentPage)
        }
    }
    
}

struct TabButton: View {
    @State var systemImage: String
    @State var tabViewType: ViewTypes
    @State var buttonColor: Color
    @Binding var currentPage: ViewTypes
    
    var body: some View {
        Button {
            currentPage = tabViewType
        } label: {
            VStack(spacing:0) {
                Image(systemName: systemImage)
                    .imageScale(.large)
                    .font(.body.bold())
                    .foregroundColor(currentPage == tabViewType ? buttonColor : Color(UIColor.lightGray))
                    .padding(.horizontal)
            }
            .frame(maxWidth: .infinity)
        }
        .overlay(
            GeometryReader { proxy in
                Color.clear.preference(key: TabPreferenceKey.self, value: proxy.size.width)
            }
        )
        
    }
}

struct ControlCenter_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            Spacer()
            ControlCenter(currentPage:Binding.constant(ViewTypes.swipeView))
        }
    }
}


struct TabPreferenceKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
