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
        case .didTapSuggestion(let atIndex):
            handleDidTapSuggestion(atIndex)
        case .didTapResult(let atIndex):
            print()
        case .didShowResultFooter:
            handleDidShowResultFooter()
        }
    }
    
    func setupModelStateBindings() {
        modelState
            .query
            .debounce(for: .milliseconds(500), scheduler: DispatchQueue.global(qos: .userInteractive))
            .sink(receiveValue: { [weak self] debouncedQuery in
                guard let self = self, let query = self.viewState.autoSuggestQuery, !query.isEmpty else { return }
                self.getSuggestions(query: debouncedQuery)
            }).store(in: &subscribers)
    }
    
    private func handleDidTapSearch() {
        viewState.displayMode = .results
        preformSearch()
    }
    
    private func handleDidUpdateQuery(_ query: String?) {
        viewState.autoSuggestQuery = query
        guard let query = query, !query.isEmpty else {
            viewState.suggestionsSnapshot?.deleteAllItems()
            modelState.suggestedQueries.removeAll()
            return
        }
        modelState.query.send(query)
    }
    
    private func handleDidTapCancel() {
        viewState.displayMode = .results
        viewState.autoSuggestQuery = ""
        viewState.suggestionsSnapshot?.deleteAllItems()
        modelState.suggestedQueries.removeAll()
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
        modelState.suggestedQueries = queries
        snapshot.appendItems(queries, toSection: 1)
        viewState.suggestionsSnapshot = snapshot
    }
    
    private func preformSearch() {
        guard let query = viewState.autoSuggestQuery else { return }
        updatePagerIfNeeded(forQuery: query)
        searchSubscriber?.cancel()
        searchSubscriber = itemManager
            .getSearchResults(forQuery: modelState.resultsPager.currentQuery,
                              limit: modelState.resultsPager.limit,
                              offset: modelState.resultsPager.offset).sink(receiveCompletion: { [weak self] completion in
                                    self?.modelState.resultsPager.isFetchingPageResults = false
                                switch completion {
                                case .failure(let error):
                                    print(error)
                                case .finished:
                                    return
                                }
            }, receiveValue: { [weak self] response in
                self?.handleSearchResponse(response)
                self?.modelState.resultsPager.isFetchingPageResults = false
            })
    }
    
    private func updatePagerIfNeeded(forQuery query: String) {
        if modelState.resultsPager.currentQuery != query {
            modelState.resultsPager = SearchResultsPager(query: query)
            viewState.searchResultsSnapshot = nil
        }
    }
    
    private func handleSearchResponse(_ response: SearchEndpoint.SearchResponse) {
        modelState.resultsPager.offset += 20
        modelState.resultsPager.total = response.paging.total
        modelState.resultsPager.hasRequestedResults = true
        
        let models = response.results!.map({ SearchResultDisplayModel(response: $0) })
        modelState.resultsPager.results.append(contentsOf: models)
        if viewState.searchResultsSnapshot != nil {
            viewState.searchResultsSnapshot?.appendItems(models, toSection: 1)
        } else {
            var snapshot = NSDiffableDataSourceSnapshot<Int, SearchResultDisplayModel>()
            snapshot.appendSections([1])
            snapshot.appendItems(models, toSection: 1)
            viewState.searchResultsSnapshot = snapshot
        }
    }
    
    private func handleDidTapSuggestion(_ index: Int) {
        viewState.displayMode = .results
        let query = modelState.suggestedQueries[index]
        getSuggestions(query: query)
        viewState.autoSuggestQuery = query
        preformSearch()
    }
    
    private func handleDidShowResultFooter() {
        guard !modelState.resultsPager.isFetchingPageResults
                && !modelState.resultsPager.hasReachedResultLimit
                && !modelState.resultsPager.isEmptyPaging else { return }
        modelState.resultsPager.isFetchingPageResults = true
        preformSearch()
    }
}

extension SearchMainViewModel {
    class ViewState {
        @Published var displayMode: DisplayMode = .suggestions
        @Published var autoSuggestQuery: String?
        @Published var suggestionsSnapshot: NSDiffableDataSourceSnapshot<Int, String>?
        @Published var searchResultsSnapshot: NSDiffableDataSourceSnapshot<Int, SearchResultDisplayModel>?
    }
    
    class ModelState {
        let query = PassthroughSubject<String, Never>()
        var suggestedQueries = [String]()
        var resultsPager = SearchResultsPager()
    }
    
    enum InputAction: Equatable {
        case didTapSearch
        case didUpdateQuery(query: String?)
        case didTapCancel
        case didFocusOnSearch
        case didTapSuggestion(atIndex: Int)
        case didTapResult(atIndex: Int)
        case didShowResultFooter
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
        var isFetchingPageResults = false
        var hasRequestedResults = false
        var hasReachedResultLimit: Bool {
            return total != 0 && results.count == total
        }
        var isEmptyPaging: Bool {
            return hasRequestedResults && total == 0
        }
        
        init() {}
        
        init(query: String) {
            currentQuery = query
        }
    }
}
