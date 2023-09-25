//
//  FeatureViewModel.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import Foundation
import UIKit

final class FeatureViewModel {
    
    let minItemSpacing: CGFloat = 40
    let cellSize = CGSize(width: UIScreen.main.bounds.width - 100, height: UIScreen.main.bounds.height - 400)
    var previousIndex = 0
    var testAry:[FeatureCellModel] = [
        FeatureCellModel(image: UIImage(systemName: "pencil"), title: "카드 스와이프"),
        FeatureCellModel(image: UIImage(systemName: "pencil"), title: "뜻 받아쓰기"),
        FeatureCellModel(image: UIImage(systemName: "pencil"), title: "뜻 받아쓰기")
    ]
}
