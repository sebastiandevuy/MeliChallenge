//
//  SuggestionTableViewCell.swift
//  MeliChallenge
//
//  Created by Pablo Gonzalez on 6/8/21.
//

import UIKit

class SuggestionTableViewCell: UITableViewCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .blue
    }
}
