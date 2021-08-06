//
//  SearchResponsePaging.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

extension SearchEndpoint {
    struct SearchResponsePaging: Decodable {
        let total: Int
        let primaryResults: Int
        let offset: Int
        let limit: Int
        
        enum CodingKeys: String, CodingKey {
            case total
            case primaryResults = "primary_results"
            case offset
            case limit
        }
    }
}
