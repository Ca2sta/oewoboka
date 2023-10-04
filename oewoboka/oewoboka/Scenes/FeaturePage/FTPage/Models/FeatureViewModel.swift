//
//  FeatureViewModel.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import Foundation
import UIKit

final class FeatureViewModel {
    
    // MARK: - titleSet
    let titleLabelText = "학습하기"
    let titleLabelFont = [NSAttributedString.Key.font: Typography.title2Medium.font]
    
    // MARK: - CellSet
    let cellSize = CGSize(width: UIScreen.main.bounds.width * 0.6, height: UIScreen.main.bounds.height * 0.5)
    let minItemSpacing: CGFloat = 40
    var previousIndex = 0
    var features:[FeatureCellModel] = [
        FeatureCellModel(
            image: UIImage(systemName: "menucard"),
            title: "단어 카드",
            description: "카드를 넘기며 단어를 외워요!",
            type: .wordCard
        ),
        FeatureCellModel(
            image: UIImage(systemName: "pencil.line"),
            title: "받아쓰기",
            description: "받아쓰기를 하며 단어를 외워요!",
            type: .dictation
        ),
        FeatureCellModel(
            image: UIImage(systemName: "note.text"),
            title: "시험 보기",
            description: "시험을 통해 어쩌구",
            type: .test
        ),
    ]
}
