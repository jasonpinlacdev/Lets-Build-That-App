//
//  SwipingController.swift
//  AutoLayout Programmatically
//
//  Created by Jason Pinlac on 7/27/20.
//  Copyright © 2020 Jason Pinlac. All rights reserved.
//

import UIKit

class SwipingController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: PageCell.cellId)
    }
}

extension SwipingController: UICollectionViewDelegateFlowLayout {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PageCell.cellId, for: indexPath) as? PageCell else { fatalError() }
        cell.backgroundColor = indexPath.row % 2 == 0 ? .systemPurple : .systemBackground
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}
