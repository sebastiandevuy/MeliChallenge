//
//  SearchEndpoint.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation
import TitanHttp

class SearchEndpoint {
    private static let url = "https://api.mercadolibre.com/sites/MLA/search"
    
    static func getRequest(request: SearchRequest) -> TitanHttpRequest {
        return TitanHttpRequest(url: url,
                                method: .get,
                                payload: .encodable(value: request,
                                                    encoding: .url),
                                headers: nil,
                                ignoreCache: true)
    }
}
