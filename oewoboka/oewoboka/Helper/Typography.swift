//
//  Typography.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/26.
//

import Foundation
import UIKit

enum Typography {
    case bigTitle
    case title1
    case title2
    case title2Medium
    case title3
    case body1
    case body2
    case body3
    
    var font: UIFont {
        switch self {
        case .bigTitle:
            return .systemFont(ofSize: 40, weight: .bold)
        case .title1:
            return .systemFont(ofSize: 30, weight: .bold)
        case .title2:
            return .systemFont(ofSize: 24, weight: .regular)
        case .title2Medium:
            return .systemFont(ofSize: 24, weight: .medium)
        case .title3:
            return .systemFont(ofSize: 20, weight: .regular)
        case .body1:
            return .systemFont(ofSize: 18, weight: .regular)
        case .body2:
            return .systemFont(ofSize: 14, weight: .regular)
        case .body3:
            return .systemFont(ofSize: 12, weight: .light)
        }
    }
}
