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
                                ignoreCache: false)
    }
}
