//
//  OnboardingModel.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/21/21.
//

import Foundation

class OnboardingModel: ObservableObject {
    
    @Published var onboardingsData = [Onboarding]()
    
    init() {
        self.onboardingsData = DataService.getLocalData()
    }

}
