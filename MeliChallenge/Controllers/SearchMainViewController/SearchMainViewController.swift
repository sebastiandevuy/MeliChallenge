//
//  SearchMainViewController.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 5/8/21.
//

import UIKit
import Combine

class SearchMainViewController: UIViewController {
    private let itemManager: ItemManager = ItemManager()
    private var subscribers = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        itemManager.getSuggestions(forQuery: "onix").sink { completion in
            print("Done")
        } receiveValue: { response in
            print(response)
        }.store(in: &subscribers)
    }
}
