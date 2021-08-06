//
//  SearchResultDisplayModel.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

struct SearchResultDisplayModel: Hashable {
    let id: String
    let title: String
    let amount: String
    let imageUrl: String
    
    init(id: String,
         title: String,
         amount: String,
         imageUrl: String) {
        self.id = id
        self.title = title
        self.amount = amount
        self.imageUrl = imageUrl
    }
    
    init(response: SearchEndpoint.SearchResponseResult) {
        self.id = response.id
        self.title = response.title
        self.amount = String(response.price)
        self.imageUrl = response.thumbnail
    }
}
