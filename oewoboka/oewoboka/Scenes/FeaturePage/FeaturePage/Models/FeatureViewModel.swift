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
    
    let cellSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.5)
    
    var previousIndex = 0
    
    var features:[FeatureCellModel] = [
        FeatureCellModel(image: UIImage(systemName: "menucard"), title: "카드 스와이프"),
        FeatureCellModel(image: UIImage(systemName: "pencil.line"), title: "받아쓰기"),
    ]
    
    
}
