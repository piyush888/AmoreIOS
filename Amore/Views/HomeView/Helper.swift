//
//  Helper.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import Foundation

enum ViewTypes {
    case messagingView
    case likesTopPicksView
    case swipeView
    case filterSettingsView
    case userSettingsView
}

enum TopPicksLikesView: String {
    case likesReceived = "Likes Received"
    case superLikesGive = "Likes Given"
    case elitePicks = "Elites"
}

enum ErrorView {
    case allServicesAreGoodView
    case serverErrorView
}

enum EditOrPreviewProfile {
    case editProfile
    case previewProfile
}

enum PopUpCards {
    
    case superLikeCards
    case boostCards
    case messagesCards
    case myAmorecards
    case amorePlatinum
    case amoreGold

}

enum MoreInformation {
    
    case introInfoHomeView
    case userHeightView
    case doYouWorkOutView
    case highestEducationView
    case doYourDrinkView
    case doYouSmokeView
    case doYouWantBabies
    case completed
}
