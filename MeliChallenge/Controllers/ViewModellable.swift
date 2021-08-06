//
//  ViewModellable.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import Foundation

protocol ViewModelable {
    associatedtype InputAction: Equatable
    associatedtype ViewState
    associatedtype ModelState
    
    func dispatchInputAction(_ action: InputAction)
    var viewState: ViewState { get }
    var modelState: ModelState { get }
}
