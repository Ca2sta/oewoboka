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
}
