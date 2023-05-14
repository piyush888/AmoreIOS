//
//  ReccomendationParent.swift
//  Amore
//
//  Created by Kshitiz Sharma on 5/8/23.
//

import SwiftUI

struct ReccomendationParent: View {
    
    @EnvironmentObject var cardProfileModel: CardProfileModel
    @EnvironmentObject var reportActivityModel: ReportActivityModel
    @EnvironmentObject var profileModel: ProfileViewModel
    @EnvironmentObject var receivedGivenEliteModel: ReceivedGivenEliteModel
    @EnvironmentObject var storeManager: StoreManager
    @EnvironmentObject var chatViewModel: ChatViewModel
    @EnvironmentObject var mainMessagesModel: MainMessagesViewModel
    
    @State var selectedProfile : CardProfileWithPhotos? = nil
    @State var showCardDetail = false
    @Binding var currentPage: ViewTypes
    @Namespace var animation
    @State var draggedIndex: Int? = nil
    @State var horizontalTranslation: CGSize = .zero
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
                    
                    let index = cardProfileModel.allCardsWithPhotosDeck.firstIndex(of: profile)
                    
                    MiniCardView(singleProfile: profile,
                                 animation: animation,
                                 miniCardWidth:size.width,
                                 miniCardHeight:size.height)
                    .animation(.interactiveSpring())
                    
                },
                               id: \.id,
                               items: cardProfileModel.allCardsWithPhotosDeck,
                               index: $currentIndex
                )
                .frame(width: geometry.size.width - 20, height: geometry.size.height/1.2, alignment: .center)
                .zIndex(0)
                
            }
            .environmentObject(cardProfileModel)
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
