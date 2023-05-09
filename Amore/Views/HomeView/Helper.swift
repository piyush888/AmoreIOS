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
    case superLikesAndLikesGiven = "Likes Given"
    case elitePicks = "Top Picks"
}


enum ProposalsView: String {
    case likesReceived = "Proposals Received"
    case superLikesAndLikesGiven = "Proposals Sent"
}

enum TopPicksLikesSubView: String {
    case likesGivenTab
    case superLikesGivenTab
    case none
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
    case rewindCards
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
