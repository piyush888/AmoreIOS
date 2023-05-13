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
    
    var threshold: CGFloat = 0.15 // when the user has draged 50% the width of the screen in either direction
    
    @State var currentIndex: Int = 0
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                VStack {
                    ButtonDesign2(buttonActive:false)
                    Spacer()
                }
                .zIndex(2)
                
                CustomCarousel(content: { profile, size in
                    MiniCardView(singleProfile: profile,
                                 animation: animation,
    //                             geometry:geometry,
                                 miniCardWidth: size.width,
                                 miniCardHeight: size.height)
//                    let index = dataArray.firstIndex(of: profile)
//                    MiniCardView(singleProfile: profile,
//                                 animation: animation,
//                                 miniCardWidth:size.width,
//                                 miniCardHeight:size.height)
//                    .animation(.interactiveSpring())
//                    .offset(x: self.draggedIndex ?? -1 == index ? self.translation.width + self.dragOffset.width : 0, y: 0)
//                    .rotationEffect(.degrees(Double(self.translation.width / geometry.size.width) * 5), anchor: .bottom)
//                    .gesture(
//                            DragGesture()
//                                .updating($dragOffset, body: { (value, state, transaction) in
//                                    state = value.translation
////                                                    DispatchQueue.main.async {
////                                                            // Do Something In Here
////                                                    }
//                                })
//                                .onChanged { value in
//                                    let translation = value.translation
//                                    let xTranslation = translation.width
//                                    let threshold = geometry.size.width / 2
//
//                                    withAnimation {
//                                        if self.draggedIndex == nil {
//                                            self.draggedIndex = index
//                                        }
//
//                                       if xTranslation > threshold || xTranslation < -threshold {
//                                           if let index = dataArray.firstIndex(of: profile) {
//                                               dataArray.remove(at: index)
//                                               self.draggedIndex = nil
//                                           }
//                                       }
//                                   }
//                                }
//                                .onEnded { _ in
//                                        withAnimation {
//                                            self.draggedIndex = nil
//                                        }
//                                    }
//                        )
                    
                }, id: \.id, items: dataArray, index: $currentIndex)
                .frame(width: geometry.size.width - 20, height: geometry.size.height/1.2, alignment: .center)
                .zIndex(0)

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
