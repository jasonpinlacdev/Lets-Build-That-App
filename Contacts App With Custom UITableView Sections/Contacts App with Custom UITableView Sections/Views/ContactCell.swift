//
//  ContactCell.swift
//  Contacts App with Custom UITableView Sections
//
//  Created by Jason Pinlac on 7/13/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

protocol ContactCellDelegate {
    func contactCellFavoriteTapped(cell: ContactCell)
}

class ContactCell: UITableViewCell {
    
    var delegate: ContactCellDelegate?
    
    var starButton: UIButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        //kind of cheat and use a hack
        starButton = UIButton(type: .system)
        starButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        starButton.setImage(ButtonImage.starFill, for: .normal)
        starButton.tintColor = .systemRed
        starButton.addTarget(self, action: #selector(handleStarButtonTapped(_:)), for: .touchUpInside)
        accessoryView = starButton
    }
    
    @objc private func handleStarButtonTapped(_ sender: UIButton) {
        delegate?.contactCellFavoriteTapped(cell: self)
    }
    
}
