//
//  SwipingController.swift
//  AutoLayout Programmatically
//
//  Created by Jason Pinlac on 7/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController {
    
    
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = .red
        pageControl.pageIndicatorTintColor = .lightGreyPink
        pageControl.currentPage = 0
        pageControl.numberOfPages = PagesBank.pages.count
        return pageControl
    }()
    
    private let previousButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("PREV", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(prevTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    private let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("NEXT", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.mainPink, for: .normal)
        button.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    
    @objc private func prevTapped(_ sender: UIButton) {
        guard pageControl.currentPage > 0 else { return }
        
        let newPage = max(pageControl.currentPage - 1, 0)
        pageControl.currentPage = newPage
        collectionView.scrollToItem(at: IndexPath(row: newPage, section: 0), at: .centeredHorizontally, animated: true)
        adjustPrevNextButtonsColor()
    }
    
    
    @objc private func nextTapped(_ sender: UIButton) {
        guard pageControl.currentPage <= PagesBank.pages.count - 2 else { return }
        
        let newPage = min(pageControl.currentPage + 1, PagesBank.pages.count - 1)
        pageControl.currentPage = newPage
        collectionView.scrollToItem(at: IndexPath(row: newPage, section: 0), at: .centeredHorizontally, animated: true)
        adjustPrevNextButtonsColor()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        setupBottomControlsLayout()
        adjustPrevNextButtonsColor()
    }
    
    
    // method for handling landscape support
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { _ in
            self.collectionViewLayout.invalidateLayout()
            
            if self.pageControl.currentPage == 0 {
                self.collectionView.contentOffset = .zero
            } else {
                let indexPath = IndexPath(row: self.pageControl.currentPage, section: 0)
                self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            }
            
            
        })
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
    
    private func adjustPrevNextButtonsColor() {
        if pageControl.currentPage == 0 {
            previousButton.setTitleColor(.gray, for: .normal)
            previousButton.isEnabled = false
        } else {
            previousButton.setTitleColor(.mainPink, for: .normal)
            previousButton.isEnabled = true
        }
        
        if pageControl.currentPage == PagesBank.pages.count - 1 {
            nextButton.setTitleColor(.gray, for: .normal)
            nextButton.isEnabled = false
        } else {
            nextButton.setTitleColor(.mainPink, for: .normal)
            nextButton.isEnabled = true
        }
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
    
    // method to determine how far we have scrolled/dragged over on the UI to adjust collection view cell we are focusing on and keep the UI in sync.
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let totalWidthOfCollection = targetContentOffset.pointee.x
        let page = Int(totalWidthOfCollection / collectionView.frame.width)
        pageControl.currentPage = page
        
        collectionView.scrollToItem(at: IndexPath(row: page, section: 0), at: .centeredHorizontally, animated: true)
        adjustPrevNextButtonsColor()
    }
}
