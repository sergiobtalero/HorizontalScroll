//
//  Sign.swift
//  HorizontalCarousel
//
//  Created by Sergio Bravo Talero on 11/10/22.
//

import UIKit

enum Sign {
    case positive
    case negative

    var multiplier: Int {
        switch self {
        case .positive:
            return 1
        case .negative:
            return -1
        }
    }

    init(value: Double) {
        if value < 0 {
            self = .negative
        }
        else {
            self = .positive
        }
    }

    init(value: CGFloat) {
        if value < 0 {
            self = .negative
        }
        else {
            self = .positive
        }
    }
}

extension CGFloat {
    var sign: Sign {
        switch self {
        case let x where x < 0:
            return .negative
        default:
            return .positive
        }
    }
}
