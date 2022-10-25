//
//  Credentials.swift
//  Amore
//
//  Created by Kshitiz Sharma on 10/17/21.
//

import Foundation


// How to use the apiBaseURL in your file?
// User this variables: Configuration.apiBaseURL.absoluteString

enum ProjectConfig {

    // MARK: - Public API

    static var apiBaseURL: URL {
        URL(string: string(for: "API_BASE_URL"))!
    }

    // MARK: - Helper Methods

    static private func string(for key: String) -> String {
        Bundle.main.infoDictionary?[key] as! String
    }

}


// Old Configurations

//let apiURL = "http://127.0.0.1:5040"
//let apiURL = "http://34.172.205.119:5040"

