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





struct FeatureCellModel {
    var image: UIImage?
    var title: String
    lazy var description = "\(self.title)를 하며 단어를 외워요!"
}


struct Constant {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    static let defalutPadding: CGFloat = 16
}
