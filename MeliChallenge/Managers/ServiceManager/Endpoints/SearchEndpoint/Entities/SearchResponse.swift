//
//  SearchResponse.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

extension SearchEndpoint {
    struct SearchResponse: Decodable {
        let query: String
        let paging: SearchResponsePaging
        let results: [SearchResponseResult]?
      
        enum CodingKeys: String, CodingKey {
            case query
            case paging
            case results
        }
    }
}
