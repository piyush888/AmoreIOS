//
//  SafetyCardWrapperView.swift
//  Amore
//
//  Created by Kshitiz Sharma on 1/16/23.
//

import SwiftUI

struct SafetyCardWrapperView: View {
    
    let cardSafety: SafetyViewModel
    let maxWidth: Double
    @Binding var showSafari:Bool
    @Binding var urlToOpen:String
    
    var body: some View {
        
        SafetyCardView(cardSafety:cardSafety,
                       maxWidth:maxWidth)
        .onTapGesture {
            if let contentUrl = cardSafety.contentUrl {
                DispatchQueue.main.async {
                    self.urlToOpen = contentUrl
                }
                self.showSafari = true
            }
        }
        
    }
}


struct SafetyCardWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        SafetyCardWrapperView(cardSafety:SafetyViewModel(id:"3",
                                                  illustration: "Dalle1",
                                                  title:"Safety",
                                                  frameHeight:140,
                                                  colorScheme: Color.green),
                      maxWidth:.infinity,
                      showSafari: Binding.constant(false),
                      urlToOpen: Binding.constant(""))
    }
}
