//
//  TableFooterView.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 7/8/21.
//

import UIKit

class TableFooterView: UIView {
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let retryButton = UIButton(type: .system)

    init() {
        super.init(frame: .zero)
        setupView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        NSLayoutConstraint.activate([activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor)])
        activityIndicator.startAnimating()
        
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        addSubview(retryButton)
        retryButton.setTitle("Reintentar", for: .normal)
        NSLayoutConstraint.activate([retryButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                                     retryButton.centerXAnchor.constraint(equalTo: centerXAnchor)])
    }
    
    func setDisplayType(_ type: DisplayType) {
        switch type {
        case .empty:
            activityIndicator.isHidden = true
            retryButton.isHidden = true
        case .loading:
            activityIndicator.isHidden = false
            retryButton.isHidden = true
        case .retry:
            activityIndicator.isHidden = true
            retryButton.isHidden = false
        }
    }
}

extension TableFooterView {
    enum DisplayType: Equatable {
        case empty
        case loading
        case retry
    }
}
