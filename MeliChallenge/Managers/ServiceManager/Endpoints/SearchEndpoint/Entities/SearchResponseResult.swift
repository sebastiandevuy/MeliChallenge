//
//  SearchResponseResult.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

extension SearchEndpoint {
    struct SearchResponseResult: Decodable {
        let id: String
        let title: String
        let price: Double
        let currencyId: String
        let thumbnail: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case title
            case price
            case currencyId = "currency_id"
            case thumbnail
        }
    }
}
