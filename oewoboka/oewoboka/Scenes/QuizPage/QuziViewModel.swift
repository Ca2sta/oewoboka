//
//  QuziViewModel.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/05.
//

import Foundation

final class QuizViewModel {
    var dateObservable: Observable<TimeInterval> = Observable(0)
    var dismissHandler: () -> Void = {}
    var featureType: Feature = .wordCard
    var quizType: QuizType = .training
    
    var isTestType: Bool { featureType == .test }
    var isWordCard: Bool { featureType == .wordCard }
    var isDictation: Bool { featureType == .dictation }
    var isMeanDictation: Bool { quizType == .meanDictation }
    var isWordDictation: Bool { quizType == .wordDictation }
}
