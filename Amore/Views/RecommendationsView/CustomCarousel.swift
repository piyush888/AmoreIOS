//
//  CustomCarousel.swift
//  Amore
//
//  Created by Piyush Garg on 10/05/23.
//

import SwiftUI

struct CustomCarousel<Content: View, Item, ID>: View where Item: RandomAccessCollection, ID: Hashable, Item.Element: Equatable {
    
    var content: (Item.Element, CGSize) -> Content
    var id: KeyPath<Item.Element, ID>
    
    var spacing: CGFloat
    var cardPadding: CGFloat
    var items: Item
    @Binding var index: Int
    
    init(@ViewBuilder content: @escaping (Item.Element, CGSize) -> Content, id: KeyPath<Item.Element, ID>, spacing: CGFloat = 30, cardPadding: CGFloat = 80, items: Item, index: Binding<Int>) {
        self.content = content
        self.id = id
        self.spacing = spacing
        self.cardPadding = cardPadding
        self.items = items
        self._index = index
    }
    
    @GestureState var translation: CGFloat = 0
    @State var offset: CGFloat = 0
    @State var lastStordedOffset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    @State var rotation: Double = 0
    
    var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let cardWidth = size.width - (cardPadding - spacing)
            let cardHeight = size.height/1.5
            LazyHStack(spacing: spacing) {
                ForEach (items, id:id) { card in
                    
                    let index = indexOf(item: card)
                    
                    content(card, CGSize(width: cardWidth - cardPadding, height: cardHeight))
                        .frame(width: size.width - cardPadding, height: cardHeight)
//                        .rotationEffect(.init(degrees: Double(index) * 5), anchor: .bottom)
//                        .rotationEffect(.init(degrees: rotation), anchor: .bottom)
                        .offset(y: offsetY(index: index, cardWidth: cardWidth))

                }
            }
            .offset(x: limitScroll())
            .gesture(
                DragGesture(minimumDistance: 5)
                    .updating($translation, body: { val, out, _ in
                        out = val.translation.width
                    })
                    .onChanged({ val in
                        carouselOnChanged(value: val, cardWidth: cardWidth)
                    })
                    .onEnded({ val in
                        carouselOnEnd(value: val, cardWidth: cardWidth)
                    })
            )
        }
        .onAppear {
            let extraSpace = (cardPadding / 2) - spacing
            offset = extraSpace
            lastStordedOffset = extraSpace
        }
        .animation(.easeInOut, value: translation == 0)
    }
    
    func offsetY(index: Int, cardWidth: CGFloat) -> CGFloat {
        // MARK: We're Converting The Current Translation, Not Whole Offset
        // That's Why Created @GestureState to Hold the Current Translation Data
        // Converting Translation to -60...60
        let progress = ((translation < 0 ? translation : -translation) / cardWidth) * 60
        let yOffset = -progress < 60 ? progress : -(progress + 120)
        
        // MARK: Checking Previous, Next And In-Between Offsets
        let previous = (index - 1) == self.index ? (translation < 0 ? yOffset : -yOffset) : 0
        let next = (index + 1) == self.index ? (translation < 0 ? -yOffset : yOffset) : 0
        let In_Between = (index - 1) == self.index ? previous : next
        
        return index == self.index ? -60 - yOffset : In_Between
    }
    
    func indexOf(item: Item.Element) -> Int {
        let array = Array(items)
        if let index = array.firstIndex(where: { element in
            element == item
        }) {
            return index
        }
        return 0
    }
    
    // MARK: Limiting Scroll on First and Last Items
    func limitScroll() -> CGFloat {
        let extraSpace = (cardPadding / 2) - spacing
        if index == 0 && translation > 0 {
            return (offset / 4) + extraSpace
        }
        else if index == items.count - 1 && translation < 0 {
            return offset - (translation / 2)
        }
        else {
            return offset
        }
    }
    
    func carouselOnChanged(value: DragGesture.Value, cardWidth: CGFloat) {
        let translationX = value.translation.width
        offset = translationX + lastStordedOffset
        
        // Rotation Calculation
        let progress = offset / cardWidth
        rotation = progress * 5
    }
    
    func carouselOnEnd(value: DragGesture.Value, cardWidth: CGFloat) {
        var _index = (offset / cardWidth).rounded()
        _index = max(-CGFloat(items.count - 1), _index)
        _index = min(_index, 0)
        
        currentIndex = Int(_index)
        // Updating Index
        //Since moving on right side, all data will be negative
        index = -currentIndex
        withAnimation(.easeInOut(duration: 0.25)) {
            let extraSpace = (cardPadding / 2) - spacing
            offset = (cardWidth * _index) + extraSpace
            
            // Rotation Calculation
            let progress = offset / cardWidth
            // since index starts with 0
            rotation = (progress * 5).rounded() - 1
        }
        lastStordedOffset = offset
    }
    
}

//struct CustomCarousel_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomCarousel()
//    }
//}
