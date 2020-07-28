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
    
    let bearImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "bear_first")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let descriptionTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        
        let attributedText = NSMutableAttributedString(string: "Join us today in our fun and games!", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.label,
        ])
        attributedText.append(NSMutableAttributedString(string: "\n\n\nAre you ready for loads and loads of fun? Don't wait any longer! We hope to see you in our store soon.", attributes: [
            .font: UIFont.boldSystemFont(ofSize: 13),
            .foregroundColor: UIColor.gray,
        ]))
        
        textView.backgroundColor = .none
        textView.attributedText = attributedText
        textView.textAlignment = .center
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    let previousButton: UIButton = {
        let button = UIButton(type: .system)
        //        button.turnOnRedBorder()
        button.setTitle("PREV", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.gray, for: .normal)
        return button
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        //        pageControl.turnOnRedBorder()
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGreyPink
        pageControl.currentPage = 1
        pageControl.numberOfPages = 4
        return pageControl
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        //        button.turnOnRedBorder()
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        return button
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        setupBottomControls()
        contentView.turnOnRedBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupLayout() {
        let topImageContainerView = UIView()
        topImageContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(topImageContainerView)
        topImageContainerView.addSubview(bearImageView)
        self.contentView.addSubview(descriptionTextView)
        
        NSLayoutConstraint.activate([
            topImageContainerView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor),
            topImageContainerView.heightAnchor.constraint(equalTo: self.contentView.heightAnchor, multiplier: 0.5),
            topImageContainerView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            topImageContainerView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
            
            bearImageView.centerYAnchor.constraint(equalTo: topImageContainerView.centerYAnchor),
            bearImageView.centerXAnchor.constraint(equalTo: topImageContainerView.centerXAnchor),
            bearImageView.heightAnchor.constraint(equalTo: topImageContainerView.heightAnchor, multiplier: 0.5),
            
            descriptionTextView.topAnchor.constraint(equalTo: topImageContainerView.bottomAnchor),
            descriptionTextView.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 24),
            descriptionTextView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -24),
            descriptionTextView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
            
        ])
    }
    
    private func setupBottomControls() {
        let yellowView = UIView()
        yellowView.backgroundColor = .systemYellow
        
        let greenView = UIView()
        greenView.backgroundColor = .systemGreen
        
        let blueView = UIView()
        blueView.backgroundColor = .systemBlue
        
        let bottomControlsStackView = UIStackView(arrangedSubviews: [
            previousButton,
            pageControl,
            nextButton
        ])
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.axis = .horizontal
        bottomControlsStackView.distribution = .fillEqually
        self.contentView.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.bottomAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
}
