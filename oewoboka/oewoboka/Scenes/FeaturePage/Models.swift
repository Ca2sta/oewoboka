//
//  FeatureCellModels.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import Foundation
import UIKit

struct FeatureCellModel {
    var image: UIImage?
    var title: String
    var description: String
    var type: Feature
}

enum Feature {
    case wordCard
    case dictation
    case test
}


struct QuizSettingData {
    let featureType: Feature
    let selectedVocabulary: [VocabularyEntity]
    let quizType: QuizType
    let quizCount: Int
}

