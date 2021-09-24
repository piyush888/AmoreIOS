//
//  DataService.swift
//  Amore
//
//  Created by Kshitiz Sharma on 9/21/21.
//

import Foundation

class DataService {
    
    // A Data type method, by adding static.. No Need to create an object
    static func getLocalData() ->[Onboarding] {
        
        // Parse the local json file
        let pathString =  Bundle.main.path(forResource: "Onboarding", ofType:"json")
        
        // Get a URL path to the json file
        guard pathString != nil else {
            return [Onboarding]()
        }
        
        // Create a URL object
        let url = URL(fileURLWithPath: pathString!)
        
        do {
            // Create a data object
            let data = try Data(contentsOf: url)
            
            // Decode the data with JSON decoder
            let decoder = JSONDecoder()
            do {
                let onboardingData = try decoder.decode([Onboarding].self, from:data)
                // return data
                return onboardingData
            }
            catch {
                // Error with parsing data
                print(error)
            }
        }
        catch {
            // Error with Finding File
            print(error)
        }
        return [Onboarding]()
    }
}
