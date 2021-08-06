//
//  SearchRequest.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

extension SearchEndpoint {
    struct SearchRequest: Encodable {
        let limit: Int
        let offset: Int
        let query: String
        
        enum CodingKeys: String, CodingKey {
            case limit
            case offset
            case query = "q"
        }
    }
}
