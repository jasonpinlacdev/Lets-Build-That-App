//
//  SwipingController.swift
//  AutoLayout Programmatically
//
//  Created by Jason Pinlac on 7/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController {
    
    var currentPage = 0 {
        didSet {
            updateViewForCurrentPage()
            collectionView.scrollToItem(at: IndexPath(row: currentPage, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(prevTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGreyPink
        pageControl.currentPage = 0
        pageControl.numberOfPages = PagesBank.pages.count
        return pageControl
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupBottomControlsLayout()
        currentPage = 0
    }
    
    
    @objc private func nextTapped(_ sender: UIButton) {
        currentPage += 1
    }
    
    @objc private func prevTapped(_ sender: UIButton) {
        currentPage -= 1
    }
    
    private func  updateViewForCurrentPage() {
        if currentPage == 0 {
            previousButton.isEnabled = false
            previousButton.setTitleColor(.gray, for: .normal)
        } else {
            previousButton.isEnabled = true
            previousButton.setTitleColor(.mainPink, for: .normal)
        }
        
        if currentPage == PagesBank.pages.count - 1 {
            nextButton.isEnabled = false
            nextButton.setTitleColor(.gray, for: .normal)
        } else {
            nextButton.isEnabled = true
            nextButton.setTitleColor(.mainPink, for: .normal)
        }
        
        pageControl.currentPage = currentPage
    }
    
    
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.cellId)
    }
    
    private func setupBottomControlsLayout() {
        let bottomControlsStackView = UIStackView(arrangedSubviews: [
            previousButton,
            pageControl,
            nextButton
        ])
        
        bottomControlsStackView.translatesAutoresizingMaskIntoConstraints = false
        bottomControlsStackView.axis = .horizontal
        bottomControlsStackView.distribution = .fillEqually
        view.addSubview(bottomControlsStackView)
        
        NSLayoutConstraint.activate([
            bottomControlsStackView.heightAnchor.constraint(equalToConstant: 50),
            bottomControlsStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomControlsStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomControlsStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
    }
    
    
}

extension SwipingController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PagesBank.pages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.cellId, for: indexPath) as? PageCell else { fatalError() }
        let page = PagesBank.pages[indexPath.row]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let totalWidthOfCollection = targetContentOffset.pointee.x
        let page = totalWidthOfCollection / collectionView.frame.width
        currentPage = Int(page)
    }
}
