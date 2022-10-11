//
//  CollectionViewCell.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 11/10/22.
//

import UIKit

extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UInt32.max)
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
           red:   .random(),
           green: .random(),
           blue:  .random(),
           alpha: 1.0
        )
    }
}

final class CollectionViewCell: UICollectionViewCell {
    public func configure() {
        contentView.backgroundColor = .random()
    }
}
