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
    var religionPreference: [String]? = ["Any"]
    var communityPreference: [String]? = ["Any"]
    var careerPreference: [String]? = ["Any"]
    var educationPreference: String? = "Masters"
    var countryPreference: String? = "India"
    var radiusDistance: CGFloat? = 100
}
