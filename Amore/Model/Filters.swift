//
//  FiltersAndLocation.swift
//  Amore
//
//  Created by Piyush Garg on 22/11/21.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Filters: Identifiable, Codable, Hashable, Equatable {
    @DocumentID public var id: String?
    var genderPreference: String? = "Male"
    var minAgePreference: Int? = 21
    var maxAgePreference: Int? = 30
    var religionPreference: [String]? = ["All (Default)"]
    var communityPreference: [String]? = ["All (Default)"]
    var careerPreference: [String]? = ["All (Default)"]
    var educationPreference: [String]? = ["All (Default)"]
    var countryPreference: [String]? = ["All (Default)"]
    var politicalPreference: [String]? = ["All (Default)"]
    var smoker: [String]? = ["All (Default)"]
    var drink: [String]? = ["All (Default)"]
    var howAreYouFeelingToday: [String]? = ["All (Default)"]
    var radiusDistance: CGFloat? = 100
}


struct FilterType: Codable, Identifiable {
    
    enum CodingKeys: CodingKey {
        case selectionFormName
        case selectionLists
    }
    
    var id = UUID()
    var selectionFormName: String
    var selectionLists: [String]
}

class LoadEditProfileFormData  {
    var editCardFormData = [FilterType]()
    
    init(){
        loadData()
    }
    
    func loadData()  {
        guard let url = Bundle.main.url(forResource: "EditCardFormData", withExtension: "json")
            else {
                print("Json file not found")
                return
            }
        
        let data = try? Data(contentsOf: url)
        let editCardFormData = try? JSONDecoder().decode([FilterType].self, from: data!)
        self.editCardFormData = editCardFormData!
    }
     
}
