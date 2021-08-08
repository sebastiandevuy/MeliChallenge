//
//  SearchResultTableViewCell.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import UIKit
import SDWebImage

class SearchResultTableViewCell: UITableViewCell {
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
        addSubview(searchImageView)
        let imageHeightConstraint = searchImageView.heightAnchor.constraint(equalToConstant: 100)
        imageHeightConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([searchImageView.widthAnchor.constraint(equalToConstant: 100),
                                     imageHeightConstraint,
                                     searchImageView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
                                     searchImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8),
                                     searchImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)])
        
        queryLabel.translatesAutoresizingMaskIntoConstraints = false
        queryLabel.numberOfLines = 0
        addSubview(queryLabel)
        NSLayoutConstraint.activate([queryLabel.centerYAnchor.constraint(equalTo: searchImageView.centerYAnchor),
                                     queryLabel.leftAnchor.constraint(equalTo: searchImageView.rightAnchor, constant: 8),
                                     queryLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8)])
    }
    
    func setupWithModel(_ model: SearchResultDisplayModel) {
        queryLabel.text = model.title
        searchImageView.sd_setImage(with: URL(string: model.imageUrl), completed: nil)
    }

}
