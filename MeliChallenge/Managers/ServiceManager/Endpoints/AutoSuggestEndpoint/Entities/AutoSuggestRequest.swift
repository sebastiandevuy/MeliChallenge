//
//  AutoSuggestRequest.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

extension AutoSuggestEndpoint {
    struct AutoSuggestRequest: Encodable {
        let showFilters: Bool
        let limit: Int
        let apiVersion = 2
        let query: String
        
        enum CodingKeys: String, CodingKey {
            case showFilters
            case limit
            case apiVersion = "api_version"
            case query = "q"
        }
    }
}
