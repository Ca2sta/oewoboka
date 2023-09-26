//
//  QuizCompleteViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class QuizCompleteViewController: UIViewController {
    
    let resultView: ResultView
    let quizFeedbackStackView: FeedBackStackView = FeedBackStackView()
    let quizResultWords: [Word]
    
    init(words: [Word]) {
        quizResultWords = words
        let memorizeWords = quizResultWords.filter { $0.isMemorize }
        let rate = CGFloat(memorizeWords.count) / CGFloat(quizResultWords.count)
        resultView = ResultView(correctRate: rate, allWordCount: quizResultWords.count, isMemorizeCount: memorizeWords.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

private extension QuizCompleteViewController {
    func setup() {
        addViews()
        autoLayoutSetup()
        resultViewSetup()
    }
    
    func addViews() {
        view.addSubview(resultView)
        view.addSubview(quizFeedbackStackView)
    }
    
    func resultViewSetup() {
        resultView.progressBarSetupAnimation()
    }
    
    func quizFeedbackSetup() {
        quizFeedbackStackView.noMemoryCount = quizResultWords.filter{ $0.isMemorize }.count
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        resultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(safeArea.snp.width).dividedBy(2)
        }
        quizFeedbackStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeArea).inset(24)
        }
    }
}
