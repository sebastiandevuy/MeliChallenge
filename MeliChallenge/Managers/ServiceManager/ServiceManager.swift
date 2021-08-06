//
//  ServiceManager.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 5/8/21.
//

import Foundation
import TitanHttp
import Combine

protocol ServiceManagerProtocol {
    func makeRequest(_ request: TitanHttpRequest) -> AnyPublisher<Data, TitanError>
}

class ServiceManager: ServiceManagerProtocol {
    private let titan: TitanRequestManager = TitanRequestManager(config: TitanConfiguration(sessionConfiguration: nil,
                                                                                            authHandler: nil))
    static let shared = ServiceManager()
    
    private init() {}
    
    func makeRequest(_ request: TitanHttpRequest) -> AnyPublisher<Data, TitanError>  {
        return titan.makeRequest(request)
    }
}
