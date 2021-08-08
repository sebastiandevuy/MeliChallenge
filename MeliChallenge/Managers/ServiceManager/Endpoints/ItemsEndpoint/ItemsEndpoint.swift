//
//  ItemsEndpoint.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 8/8/21.
//

import Foundation
import TitanHttp

class ItemsEndpoint {
    private static let url = "https://api.mercadolibre.com/items/"
    
    static func getRequest(request: ItemRequest) -> TitanHttpRequest {
        return TitanHttpRequest(url: url + request.id,
                                method: .get,
                                payload: nil,
                                headers: nil,
                                ignoreCache: false)
    }
}
