//
//  ItemDetailsViewController.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 8/8/21.
//

import UIKit

class ItemDetailsViewController: UIViewController {
    private let textView = UITextView()
    private let viewModel: ItemDetailsViewModel
    
    init(viewModel: ItemDetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func setupView() {
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        view.addSubview(textView)
        NSLayoutConstraint.activate([textView.topAnchor.constraint(equalTo: view.topAnchor),
                                     textView.leftAnchor.constraint(equalTo: view.leftAnchor),
                                     textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                                     textView.rightAnchor.constraint(equalTo: view.rightAnchor)])
        textView.text = viewModel.viewState.json
    }
}
