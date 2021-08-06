//
//  AutoSuggestResponse.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

extension AutoSuggestEndpoint {
    struct AutoSuggestResponse: Decodable {
        let query: String
        let suggestedQueries: [SuggestedQuery]?
        
        enum CodingKeys: String, CodingKey {
            case query = "q"
            case suggestedQueries = "suggested_queries"
        }
        
        struct SuggestedQuery: Decodable {
            let query: String
            
            enum CodingKeys: String, CodingKey {
                case query = "q"
            }
        }
    }
}
