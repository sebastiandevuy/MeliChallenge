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
                                                                                        limit: 10,
                                                                                        query: query)))
            .decode(type: AutoSuggestEndpoint.AutoSuggestResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}



//https://developers.mercadolibre.com.ar/es_ar/items-y-busquedas
//
//Search
//
//https://api.mercadolibre.com/sites/MLA/search?q=Prada&limit=10&offset=230
//
//Details
//
//https://api.mercadolibre.com/items/MLA609335270
//
//https://api.mercadolibre.com/items/MLU464927558
//
//AutoSuggest
//
//https://api.mercadolibre.com/sites/MLA/autosuggest?showFilters=true&limit=6&api_version=2&q=nvidia%20gfo
