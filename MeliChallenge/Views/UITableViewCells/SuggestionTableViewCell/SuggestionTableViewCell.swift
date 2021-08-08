//
//  SuggestionTableViewCell.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {
    private let searchImageView = UIImageView()
    private let queryLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        searchImageView.translatesAutoresizingMaskIntoConstraints = false
        searchImageView.image = UIImage(named: "searchIcon")
        addSubview(searchImageView)
        let imageHeightConstraint = searchImageView.heightAnchor.constraint(equalToConstant: 25)
        imageHeightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([searchImageView.widthAnchor.constraint(equalToConstant: 25),
                                     imageHeightConstraint,
                                     searchImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                                     searchImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
                                     searchImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
        
        queryLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(queryLabel)
        NSLayoutConstraint.activate([queryLabel.centerYAnchor.constraint(equalTo: searchImageView.centerYAnchor),
                                     queryLabel.leftAnchor.constraint(equalTo: searchImageView.rightAnchor, constant: 8),
                                     queryLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
    }
    
    func setupWithQuery(_ query: String) {
        queryLabel.text = query
    }
}
