//
//  ViewController.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 11/10/22.
//

import UIKit

final class ViewController: UIViewController {
    private lazy var peekingBehavior: MSCollectionViewPeekingBehavior = {
        let behavior = MSCollectionViewPeekingBehavior()
        return behavior
    }()
    
    private lazy var collectionView: UICollectionView = {
        
        let _collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: peekingBehavior.layout)
        _collectionView.delegate = self
        _collectionView.dataSource = self
        _collectionView.register(CollectionViewCell.self,
                                 forCellWithReuseIdentifier: "CollectionViewCell")
        return _collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carousel"
        setupUI()
    }
}

private extension ViewController {
    private enum Constants {
        static let collectionViewHeight: CGFloat = 300
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
    func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                   withVelocity velocity: CGPoint,
                                   targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        peekingBehavior.scrollViewWillEndDragging(scrollView,
                                                  withVelocity: velocity,
                                                  targetContentOffset: targetContentOffset)
    }
}
