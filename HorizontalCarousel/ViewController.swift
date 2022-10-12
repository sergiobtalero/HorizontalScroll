//
//  ViewController.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 11/10/22.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let horizontalInset = Constants.peekWidth
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = .zero
        layout.sectionInset = UIEdgeInsets(top: .zero,
                                           left: horizontalInset,
                                           bottom: .zero,
                                           right: horizontalInset)
        layout.itemSize = CGSize(width: view.bounds.size.width - horizontalInset * 2,
                                 height: Constants.collectionViewHeight)
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
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carousel"
        setupUI()
    }
}

private extension ViewController {
    private enum Constants {
        static let collectionViewHeight: CGFloat = 300
        static let peekWidth: CGFloat = 65
    }
}

// MARK: - Setup UI
private extension ViewController {
    private func setupUI() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: Constants.collectionViewHeight)
        ])
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell",
                                                      for: indexPath) as! CollectionViewCell
        cell.configure()
        return cell
    }
}

extension ViewController: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        indexOfCellBeforeDragging = getIndexOfMainVisibleCell()
    }
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        targetContentOffset.pointee = scrollView.contentOffset
        let swipeVelocityThreshold: CGFloat = 0.5
        let indexOfVisibleCell = getIndexOfMainVisibleCell()
        let didMainVisibleCellNotChanged = indexOfVisibleCell == indexOfCellBeforeDragging
        let isVelocityEnoughForNextCell = indexOfCellBeforeDragging + 1 < 4 && velocity.x > swipeVelocityThreshold
        let isVelocityEnoughForPreviousCell = indexOfCellBeforeDragging - 1 > .zero && velocity.x < -swipeVelocityThreshold
        let didUseSwipeToSkipCell = didMainVisibleCellNotChanged && (isVelocityEnoughForNextCell || isVelocityEnoughForPreviousCell)
        if didUseSwipeToSkipCell,
            let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            let snapToIndex = indexOfCellBeforeDragging + (isVelocityEnoughForNextCell ? 1 : -1)
            let toValue = collectionViewLayout.itemSize.width * CGFloat(snapToIndex)
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: velocity.x, options: .allowUserInteraction, animations: {
                scrollView.contentOffset = CGPoint(x: toValue, y: 0)
                scrollView.layoutIfNeeded()
            }, completion: nil)
        } else {
            let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
            flowLayout?.collectionView?.scrollToItem(at: IndexPath(row: indexOfVisibleCell, section: .zero),
                                                     at: .centeredHorizontally,
                                                     animated: true)
        }
    }
}

// MARK: - Private methods
extension ViewController {
    private func getIndexOfMainVisibleCell() -> Int {
        guard
            let collectionViewLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout,
            let contentOffset = collectionViewLayout.collectionView?.contentOffset else {
            return .zero
        }
        
        let itemWidth = collectionViewLayout.itemSize.width
        let proportionalOffset = contentOffset.x / itemWidth
        let index = Int(round(proportionalOffset))
        let numberOfItems = collectionView.numberOfItems(inSection: .zero)
        return max(.zero, min(numberOfItems - 1, index))
    }
}
