//
//  SearchMainViewModelTests.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 8/8/21.
//  
//

import Quick
import Nimble
import Foundation
@testable import MeliChallenge

class SearchMainViewModelTests: QuickSpec {
    override func spec() {
        var subject: SearchMainViewModel!
        var itemManagerMock: ItemManagerMock!
        var navigatorMock: NavigatorMock!
        
        beforeEach {
            itemManagerMock = ItemManagerMock()
            navigatorMock = NavigatorMock()
            subject = SearchMainViewModel(itemManager: itemManagerMock,
                                          navigator: navigatorMock)
        }
        
        describe("input actions") {
            context("didTapSearch") {
                beforeEach {
                    subject.viewState.autoSuggestQuery = "dummyStuff"
                    subject.dispatchInputAction(.didTapSearch)
                }
                
                it("should set display mode, update pager and perfom search") {
                    expect(subject.viewState.displayMode).to(equal(.results))
                    expect(subject.modelState.resultsPager.currentQuery).to(equal("dummyStuff"))
                    expect(subject.viewState.searchResultsSnapshot).to(beNil())
                    expect(itemManagerMock.getSearchResultsInvocationParams).toNot(beNil())
                    expect(subject.viewState.searchResultsSnapshot).to(beNil())
                }
                
                context("service call fails") {
                    beforeEach {
                        itemManagerMock.resolveGetSearchResults(withResult: .failure(NSError(domain: "", code: -1, userInfo: nil)))
                    }
                    
                    it("should set the footer to retry mode") {
                        expect(subject.viewState.resultFooterDisplayType).to(equal(.retry))
                    }
                }
                
                context("service call succeeds") {
                    beforeEach {
                        itemManagerMock.resolveGetSearchResults(withResult: .success(SearchEndpoint.SearchResponse(query: "dummyStuff", paging: SearchEndpoint.SearchResponsePaging(total: 1, primaryResults: 1, offset: 0, limit: 20), results: [SearchEndpoint.SearchResponseResult(id: "ML1234", title: "someTitle", price: 123, currencyId: "USD", thumbnail: "https://www.tt.com/t.jpg")])))
                    }
                    
                    it("should update pager, results and snapshot") {
                        expect(subject.modelState.resultsPager.offset).to(equal(20))
                        expect(subject.modelState.resultsPager.total).to(equal(1))
                        expect(subject.modelState.resultsPager.hasRequestedResults).to(beTrue())
                        expect(subject.modelState.resultsPager.results.count).to(equal(1))
                        expect(subject.viewState.searchResultsSnapshot).toNot(beNil())
                    }
                }
            }
            
            context("didUpdateQuery") {
                beforeEach {
                    subject.dispatchInputAction(.didUpdateQuery(query: "hola"))
                    subject.dispatchInputAction(.didUpdateQuery(query: "hola Mun"))
                    subject.dispatchInputAction(.didUpdateQuery(query: "hola Mundo"))
                }
                
                it("should update autosuggest query with latest and debounce search for it") {
                    expect(subject.viewState.autoSuggestQuery).to(equal("hola Mundo"))
                    expect(itemManagerMock.getSuggestionsInvocationParam).to(beNil())
                    expect(itemManagerMock.getSuggestionsInvocationParam).toEventually((equal("hola Mundo")))
                    expect(subject.viewState.suggestionsSnapshot).to(beNil())
                }
            }
        }
    }
}
