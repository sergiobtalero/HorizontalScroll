//
//  Axis.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 11/10/22.
//

import Foundation
import UIKit

/// Defines the possible cases of a collection view axis.
enum Axis {

    /// Represents the main axis in the direction of paging
    case main

    /// Represents the cross axis perpendicular to the direction of paging
    case cross
}

extension CGPoint {
    func attribute(axis: Axis, scrollDirection: UICollectionView.ScrollDirection) -> CGFloat {
        switch (axis, scrollDirection) {
        case (.main, .horizontal), (.cross, .vertical):
            return x
        case (.main, .vertical), (.cross, .horizontal):
            return y
        default:
            assertionFailure("Not implemented")
            return 0
        }
    }
}
