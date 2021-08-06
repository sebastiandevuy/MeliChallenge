//
//  SearchMainViewModel.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation
import Combine
import UIKit

class SearchMainViewModel: ViewModelable {
    var viewState: ViewState = ViewState()
    var modelState: ModelState = ModelState()
    
    private let itemManager: ItemManager
    private var subscribers = Set<AnyCancellable>()
    private var getSuggestionsSubscriber: AnyCancellable?
    private var searchSubscriber: AnyCancellable?
    
    
    init(itemManager: ItemManager = ItemManager()) {
        self.itemManager = itemManager
        setupModelStateBindings()
    }
    
    func dispatchInputAction(_ action: InputAction) {
        switch action {
        case .didTapSearch:
            handleDidTapSearch()
        case .didUpdateQuery(let query):
            handleDidUpdateQuery(query)
        case .didTapCancel:
            handleDidTapCancel()
        case .didFocusOnSearch:
            handleDidFocusOnSearch()
        }
    }
    
    func setupModelStateBindings() {
        modelState
            .query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .userInteractive))
            .sink(receiveValue: { [weak self] debouncedQuery in
                self?.getSuggestions(query: debouncedQuery)
            }).store(in: &subscribers)
    }
    
    private func handleDidTapSearch() {
        viewState.displayMode = .results
        preformSearch()
    }
    
    private func handleDidUpdateQuery(_ query: String?) {
        viewState.searchQuery = query
        guard let query = query else { return }
        modelState.query.send(query)
    }
    
    private func handleDidTapCancel() {
        viewState.displayMode = .results
    }
    
    private func handleDidFocusOnSearch() {
        viewState.displayMode = .suggestions
    }
    
    private func getSuggestions(query: String) {
        getSuggestionsSubscriber?.cancel()
        getSuggestionsSubscriber = itemManager
            .getSuggestions(forQuery: query)
            .sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] response in
                self?.setupSuggestionsSnapshotFromResponse(response)
            })
    }
    
    private func setupSuggestionsSnapshotFromResponse(_ response:  AutoSuggestEndpoint.AutoSuggestResponse) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([1])
        let queries = response.suggestedQueries!.map({return $0.query})
        snapshot.appendItems(queries, toSection: 1)
        viewState.suggestionsSnapshot = snapshot
    }
    
    private func preformSearch() {
        guard let query = viewState.searchQuery else { return }
        searchSubscriber?.cancel()
        searchSubscriber = itemManager
            .getSearchResults(forQuery: query, limit: 20, offset: 0).sink(receiveCompletion: { completion in
                print(completion)
            }, receiveValue: { [weak self] response in
                self?.handleSearchResponse(response)
            })
    }
    
    private func updatePager(forQuery query: String) {
        if modelState.resultsPager.currentQuery != query {
            modelState.resultsPager = SearchResultsPager(query: query)
        }
    }
    
    private func handleSearchResponse(_ response: SearchEndpoint.SearchResponse) {
        var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResultDisplayModel>()
        snapshot.appendSections([1])
        let models = response.results!.map({ SearchResultDisplayModel(response: $0) })
        snapshot.appendItems(models, toSection: 1)
        viewState.searchResultsSnapshot = snapshot
    }
}

extension SearchMainViewModel {
    class ViewState {
        @Published var displayMode: DisplayMode = .suggestions
        @Published var searchQuery: String?
        @Published var suggestionsSnapshot: NSDiffableDataSourceSnapshot<Int, String>?
        @Published var searchResultsSnapshot: NSDiffableDataSourceSnapshot<Int, SearchResultDisplayModel>?
    }
    
    class ModelState {
        let query = PassthroughSubject<String, Never>()
        var resultsPager = SearchResultsPager()
    }
    
    enum InputAction: Equatable {
        case didTapSearch
        case didUpdateQuery(query: String?)
        case didTapCancel
        case didFocusOnSearch
    }
    
    enum DisplayMode: Equatable {
        case suggestions
        case results
    }
    
    class SearchResultsPager {
        let limit = 20
        var offset = 0
        var total = 0
        var results = [SearchResultDisplayModel]()
        var currentQuery = ""
        
        init() {}
        
        init(query: String) {
            currentQuery = query
        }
    }
}
