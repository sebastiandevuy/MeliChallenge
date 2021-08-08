//
//  ItemManagerMock.swift
//  MeliChallengeTests
//
//  Created by Pablo Gonzalez on 8/8/21.
//

import Foundation
import Combine
@testable import MeliChallenge

class ItemManagerMock: ItemManagerProtocol {
    private let getSearchResultsPublisher = PassthroughSubject<SearchEndpoint.SearchResponse, Error>()
    private let getSuggestionsPublisher = PassthroughSubject<AutoSuggestEndpoint.AutoSuggestResponse, Error>()
    
    var getSearchResultsInvocationParams: (query: String, limit: Int, offset: Int)?
    var getSuggestionsInvocationParam: String?
    
    func getSuggestions(forQuery query: String) -> AnyPublisher<AutoSuggestEndpoint.AutoSuggestResponse, Error> {
        getSuggestionsInvocationParam = query
        return getSuggestionsPublisher.eraseToAnyPublisher()
    }
    
    func getSearchResults(forQuery query: String, limit: Int, offset: Int) -> AnyPublisher<SearchEndpoint.SearchResponse, Error> {
        getSearchResultsInvocationParams = (query: query, limit: limit, offset: offset)
        return getSearchResultsPublisher.eraseToAnyPublisher()
    }
    
    func getItem(itemId: String) -> AnyPublisher<String, Error> {
        fatalError()
    }
    
    func resolveGetSearchResults(withResult result: Result<SearchEndpoint.SearchResponse, Error>) {
        switch result {
        case .success(let response):
            getSearchResultsPublisher.send(response)
        case .failure(let error):
            getSearchResultsPublisher.send(completion: .failure(error))
        }
    }
    
    func resolveGetSuggestions(withResult result: Result<AutoSuggestEndpoint.AutoSuggestResponse, Error>) {
        switch result {
        case .success(let response):
            getSuggestionsPublisher.send(response)
        case .failure(let error):
            getSuggestionsPublisher.send(completion: .failure(error))
        }
    }
}
