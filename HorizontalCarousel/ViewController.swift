//
//  ViewController.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 11/10/22.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Carousel"
        setupUI()
    }
}

// MARK: - Setup UI
private extension ViewController {
    private func setupUI() {
        let horizontalCarouselView = HorizontalCarouselView(numberOfCellsToShow: 5,
                                                            itemHeight: 300,
                                                            frame: view.bounds)
        horizontalCarouselView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(horizontalCarouselView)
        
        NSLayoutConstraint.activate([
            horizontalCarouselView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            horizontalCarouselView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            horizontalCarouselView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            horizontalCarouselView.heightAnchor.constraint(equalToConstant: 300)
        ])
    }
}
