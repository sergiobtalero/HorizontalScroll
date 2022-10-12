//
//  HorizontalCarouselView.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 12/10/22.
//

import UIKit

final class HorizontalCarouselView: UIView {
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let horizontalInset = Constants.peekWidth
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero,
                                           left: horizontalInset,
                                           bottom: .zero,
                                           right: horizontalInset)
        layout.itemSize = CGSize(width: bounds.size.width - horizontalInset * 2,
                                 height: itemHeight)
        return layout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let _collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: flowLayout)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.showsHorizontalScrollIndicator = false
        _collectionView.register(CollectionViewCell.self,
                                 forCellWithReuseIdentifier: "CollectionViewCell")
        return _collectionView
    }()
    
    private var indexOfCellBeforeDragging: Int = .zero
    private let numberOfCellsToShow: Int
    private let itemHeight: CGFloat
    
    // MARK: - Initializers
    init(numberOfCellsToShow: Int,
         itemHeight: CGFloat,
         frame: CGRect) {
        self.numberOfCellsToShow = numberOfCellsToShow
        self.itemHeight = itemHeight
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Constants
private extension HorizontalCarouselView {
    private enum Constants {
        static let peekWidth: CGFloat = 55
    }
}

// MARK: - View setup
private extension HorizontalCarouselView {
    private func setupView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension HorizontalCarouselView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        numberOfCellsToShow
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                      for: indexPath) as! CollectionViewCell
        cell.configure()
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HorizontalCarouselView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = getIndexOfMainVisibleCell()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Stop scrollView sliding
        targetContentOffset.pointee = scrollView.contentOffset
        
        // Calculate where scrollView should snap
        let indexOfMajorCell = getIndexOfMainVisibleCell()
        
        // Calculate conditions
        let swipeVelocityThreshold: CGFloat = 0.5 // after some trail and error
        let hasEnoughVelocityToSlideToTheNextCell = indexOfCellBeforeDragging + 1 < numberOfCellsToShow && velocity.x > swipeVelocityThreshold
        let hasEnoughVelocityToSlideToThePreviousCell = indexOfCellBeforeDragging - 1 >= 0 && velocity.x < -swipeVelocityThreshold
        let majorCellIsTheCellBeforeDragging = indexOfMajorCell == indexOfCellBeforeDragging
        let didUseSwipeToSkipCell = majorCellIsTheCellBeforeDragging && (hasEnoughVelocityToSlideToTheNextCell || hasEnoughVelocityToSlideToThePreviousCell)
        
        if didUseSwipeToSkipCell {
            let snapToIndex = indexOfCellBeforeDragging + (hasEnoughVelocityToSlideToTheNextCell ? 1 : -1)
            let toValue = flowLayout.itemSize.width * CGFloat(snapToIndex)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            flowLayout.collectionView?.scrollToItem(at: IndexPath(row: indexOfMajorCell, section: .zero),
                                                     at: .centeredHorizontally,
                                                     animated: true)
        }
    }
}

// MARK: - Private methods
extension HorizontalCarouselView {
    private func getIndexOfMainVisibleCell() -> Int {
        let itemWidth = flowLayout.itemSize.width
        let proportionalOffset = (flowLayout.collectionView?.contentOffset ?? .zero).x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: .zero)
        return max(.zero, min(numberOfItems - 1, index))
    }
}
