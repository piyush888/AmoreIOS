//
//  ReccomendationParent.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/8/23.
//

import SwiftUI

struct ReccomendationParent: View {
    
    @State var dataArray: [CardProfileWithPhotos]
    @State var selectedProfile : CardProfileWithPhotos? = nil
    @State var showCardDetail = false
    @Binding var currentPage: ViewTypes
    @Namespace var animation
    @State var draggedIndex: Int? = nil
    @State var translation: CGSize = .zero
    @GestureState var dragOffset: CGSize = .zero
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                
                ButtonDesign2(buttonActive:false)
                
                ZStack {
                    ScrollView{
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(),spacing: 10), count: 1),spacing: 10){
                            ForEach(dataArray) { profile in
//                                let profile = dataArray[index]
                                let index = dataArray.firstIndex(of: profile)
                                Button{
                                    withAnimation(.spring()){
                                        selectedProfile = profile
                                        showCardDetail = true
                                    }
                                } label : {
                                    
                                    MiniCardView(singleProfile: profile,
                                                 animation: animation,
                                                 geometry:geometry,
                                                 miniCardWidth:geometry.size.width,
                                                 miniCardHeight:geometry.size.height/1.5)
                                    .animation(.interactiveSpring())
                                    .offset(x: self.draggedIndex ?? -1 == index ? self.translation.width + self.dragOffset.width : 0, y: 0)
                                    .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 5), anchor: .bottom)
                                    .gesture(
                                            DragGesture()
                                                .updating($dragOffset, body: { (value, state, transaction) in
                                                    state = value.translation
//                                                    DispatchQueue.main.async {
//                                                            // Do Something In Here
//                                                    }
                                                })
                                                .onChanged { value in
                                                    let translation = value.translation
                                                    let threshold = geometry.size.width / 3
                                                    
                                                    withAnimation {
                                                        if self.draggedIndex == nil {
                                                            self.draggedIndex = index
                                                        }
                                                        
                                                       if translation.width > threshold || translation.width < -threshold {
                                                           if let index = dataArray.firstIndex(of: profile) {
                                                               dataArray.remove(at: index)
                                                               self.draggedIndex = nil
                                                           }
                                                       }
                                                   }
                                                }
                                                .onEnded { _ in
                                                        withAnimation {
                                                            self.draggedIndex = nil
                                                        }
                                                    }
                                        )
                                }
                            }
                        }
                        .padding()
                    }
                    
                }
                .sheet(isPresented: $showCardDetail, content: {
                    if let selectedItem = selectedProfile {
                        ZStack {
                            ChildCardView(singleProfile: selectedItem,
                                          swipeStatus: Binding.constant(AllCardsView.LikeDislike.none),
                                          cardColor: Binding.constant(Color.pink))
                            .ignoresSafeArea(.all, edges: .bottom)
                            
                            ButtonDesign(buttonActive:false)
                        }
                    }
                })
            }
        }
    }
}

//struct ReccomendationParent_Previews: PreviewProvider {
//    static var previews: some View {
//        ReccomendationParent()
//    }
//}
