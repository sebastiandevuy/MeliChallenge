//
//  ItemDetailsViewModel.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 8/8/21.
//

import Foundation

class ItemDetailsViewModel: ViewModelable {
    var viewState: ViewState
    var modelState = ModelState()
    
    init(build: Build) {
        viewState = ViewState(json: build.json)
    }
    
    func dispatchInputAction(_ action: InputAction) {
        
    }
}

extension ItemDetailsViewModel {
    class ViewState {
        let json: String
        
        init(json: String) {
            self.json = json
        }
    }
    
    class ModelState {}
    
    enum InputAction: Equatable {}
    
    struct Build {
        let json: String
    }
}
