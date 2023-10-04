//
//  FTOPViewModel.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/28.
//

import Foundation
import UIKit

final class FTOPViewModel {
    
    init() {
        print("viewModel init")
    }
    // MARK: - RangeView
    let rangeViewTitle = "문제 범위"
    let rangeViewDescription = "여러 단어장을 선택할 수 있어요"
    
    // MARK: - TypeView
    let typeViewTitle = "문제 타입"
    let typeViewDescription = "공부하고 싶은 항목을 선택해 주세요"
    let features = [
        "단어",
        "의미"
    ]
    
    // MARK: - QuizSettingView
    let rangeBTLeftImage = UIImage(systemName: "person.fill")
    let rangeBTtitle = "단어장 선택"
    let rangeBTRightImage = UIImage(systemName: "person")
    var quizType: QuizType = .wordDictation

    // MARK: - QuizCountView
    let countViewTitle = "문제 갯수 제한"
    let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.screenHeight * 0.03)
    var count: Observable<Int> = Observable(10)
    lazy var countViewPlusBTImage = UIImage(
        systemName: "plus.circle", withConfiguration: self.imageConfig
    )
    lazy var countViewMinusImage = UIImage(
        systemName: "minus.circle", withConfiguration: self.imageConfig
    )
    
    // MARK: - BottomView
    let startBTTitle = "퀴즈 시작"
    let startBTImage = UIImage(systemName: "person")

    
}

