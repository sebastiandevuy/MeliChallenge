//
//  ItemManager.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 5/8/21.
//

import Foundation
import Combine

protocol ItemManagerProtocol {
    func getSuggestions(forQuery query: String) -> AnyPublisher<AutoSuggestEndpoint.AutoSuggestResponse, Error>
    func getSearchResults(forQuery query: String,
                          limit: Int,
                          offset: Int) -> AnyPublisher<SearchEndpoint.SearchResponse, Error>
}

class ItemManager: ItemManagerProtocol {
    private let serviceManager: ServiceManagerProtocol
    
    init(serviceManager: ServiceManagerProtocol = ServiceManager.shared) {
        self.serviceManager = serviceManager
    }
    
    func getSuggestions(forQuery query: String) -> AnyPublisher<AutoSuggestEndpoint.AutoSuggestResponse, Error> {
        return serviceManager
            .makeRequest(AutoSuggestEndpoint
                            .getRequest(request: AutoSuggestEndpoint.AutoSuggestRequest(showFilters: true,
                                                                                        limit: 20,
                                                                                        query: query)))
            .decode(type: AutoSuggestEndpoint.AutoSuggestResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func getSearchResults(forQuery query: String, limit: Int, offset: Int) -> AnyPublisher<SearchEndpoint.SearchResponse, Error> {
        return serviceManager
            .makeRequest(SearchEndpoint.getRequest(request: SearchEndpoint.SearchRequest(limit: limit,
                                                                                         offset: offset,
                                                                                         query: query)))
            .decode(type: SearchEndpoint.SearchResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}

//Details
//
//https://api.mercadolibre.com/items/MLA609335270
//
//https://api.mercadolibre.com/items/MLU464927558
