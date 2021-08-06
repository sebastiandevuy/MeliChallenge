//
//  AutoSuggestEndpoint.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 5/8/21.
//

import Foundation
import TitanHttp

class AutoSuggestEndpoint {
    private static let url = "https://api.mercadolibre.com/sites/MLA/autosuggest"
    
    static func getRequest(request: AutoSuggestRequest) -> TitanHttpRequest {
        return TitanHttpRequest(url: url,
                                method: .get,
                                payload: .encodable(value: request,
                                                    encoding: .url),
                                headers: nil,
                                ignoreCache: true)
    }
}

extension AutoSuggestEndpoint {
    struct AutoSuggestRequest: Encodable {
        let showFilters: Bool
        let limit: Int
        let apiVersion = 2
        let query: String
        
        enum CodingKeys: String, CodingKey {
            case showFilters
            case limit
            case apiVersion = "api_version"
            case query = "q"
        }
    }
    
    struct AutoSuggestResponse: Decodable {
        let query: String
        let suggestedQueries: [SuggestedQuery]?
        
        enum CodingKeys: String, CodingKey {
            case query = "q"
            case suggestedQueries = "suggested_queries"
        }
        
        struct SuggestedQuery: Decodable {
            let query: String
            
            enum CodingKeys: String, CodingKey {
                case query = "q"
            }
        }
    }
}
