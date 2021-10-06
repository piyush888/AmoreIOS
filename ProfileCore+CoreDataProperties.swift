//
//  ProfileCore+CoreDataProperties.swift
//  Amore
//
//  Created by Piyush Garg on 05/10/21.
//
//

import Foundation
import CoreData


extension ProfileCore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileCore> {
        return NSFetchRequest<ProfileCore>(entityName: "ProfileCore")
    }

    @NSManaged public var id: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var email: String?
    @NSManaged public var dateOfBirth: Date?
    @NSManaged public var interests: [String]?
    @NSManaged public var genderIdentity: String?
    @NSManaged public var sexualOrientation: [String]?
    @NSManaged public var sexualOrientationVisible: Bool
    @NSManaged public var showMePreference: String?
    @NSManaged public var work: String?
    @NSManaged public var school: String?

}

extension ProfileCore : Identifiable {

}
