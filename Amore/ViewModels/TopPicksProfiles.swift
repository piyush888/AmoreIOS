//
//  TopPicksProfiles.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/18/21.
//

import SwiftUI

// Item Model And Sample Data....

struct TopPicksProfiles: Identifiable {
    
    var id = UUID().uuidString
    var firstName: String
    var subTitle: String
    var price: String
    var age: String
    var image: String
}

// Note Both Image And Color Name Are Same....

var TopPicksProfilesList = [

    TopPicksProfiles(firstName: "Riya", subTitle: "Black Full Rim", price: "$36", age: "25",image: "girl3_image1"),
    TopPicksProfiles(firstName: "Missy", subTitle: "Brown Tortoise", price: "$45", age: "26",image: "girl1_image6"),
    TopPicksProfiles(firstName: "Andrea", subTitle: "Office Glass", price: "$84", age: "22",image: "girl2_image2"),
    TopPicksProfiles(firstName: "Karolina", subTitle: "Fashion U", price: "$65", age: "27",image: "girl2_image6"),
    TopPicksProfiles(firstName: "Mercy", subTitle: "Investment Bank", price: "$65", age: "27",image: "girl1_image3"),
    TopPicksProfiles(firstName: "Jane", subTitle: "", price: "$65", age: "27",image: "girl1_image4"),
    TopPicksProfiles(firstName: "Ellen", subTitle: "Capital Mgmt", price: "$65", age: "27",image: "girl2_image4"),
]
