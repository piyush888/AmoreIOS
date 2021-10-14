//
//  ViewRouter.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/11/21.
//

import SwiftUI

enum Page {
    case page1
    case page2
}


class ViewRouter: ObservableObject {
    @Published var currentPage: Page = .page1
}
