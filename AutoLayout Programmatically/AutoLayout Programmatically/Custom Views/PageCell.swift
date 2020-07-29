//
//  PageCell.swift
//  AutoLayout Programmatically
//
//  Created by Jason Pinlac on 7/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell {
    
    static let cellId = "PageCell"
    
    var page: Page? {
        didSet {
            if let page = page {
                imageView.image = UIImage(named: page.imageName)
                let attributedText = NSMutableAttributedString(string: page.headerText, attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 18),
                    .foregroundColor: UIColor.black,
                ])
                attributedText.append(NSMutableAttributedString(string: page.bodyText, attributes: [
                    .font: UIFont.boldSystemFont(ofSize: 13),
                    .foregroundColor: UIColor.gray,
                ]))
                descriptionTextView.attributedText = attributedText
                descriptionTextView.textAlignment = .center
                
            }
        }
    }
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .none
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(topImageContainerView)
        topImageContainerView.addSubview(imageView)
        self.contentView.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5),
            topImageContainerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            imageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            imageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5),
            
            descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
}
