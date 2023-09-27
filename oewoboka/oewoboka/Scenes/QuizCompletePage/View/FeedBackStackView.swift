//
//  FeedBackStackView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/26.
//

import UIKit

final class FeedBackStackView: UIStackView {
    
    private let quizAnswerButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "exclamationmark.bubble")
        button.text = "퀴즈 정답보기"
        return button
    }()
    private let reQuizButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "arrow.clockwise")
        button.text = "다시하기"
        return button
    }()
    private let unMemorizeWordReQuizButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "arrow.clockwise")
        button.text = "모르는 문제 다시 풀기"
        return button
    }()
    var popHandler: ((QuizResultType) -> Void)?
    var unMemorizeCount: Int = 0 {
        didSet {
            let isUnMemorizeWordZero = unMemorizeCount == 0
            unMemorizeWordReQuizButton.isHidden = isUnMemorizeWordZero
            unMemorizeWordReQuizButton.text = "모르는 \(unMemorizeCount)문제 다시 풀기"
        }
    }

    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: UI Init
private extension FeedBackStackView {
    func setup() {
        initStackView()
        addViews()
        buttonSetup()
    }
    
    func initStackView() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 16
    }
    
    func addViews() {
        addArrangedSubview(quizAnswerButton)
        addArrangedSubview(reQuizButton)
        addArrangedSubview(unMemorizeWordReQuizButton)
    }
    
    func buttonSetup() {
        quizAnswerButton.addTarget(self, action: #selector(reQuizeButtonClik), for: .touchUpInside)
        reQuizButton.addTarget(self, action: #selector(reQuizeButtonClik), for: .touchUpInside)
        unMemorizeWordReQuizButton.addTarget(self, action: #selector(unMemorizeReQuizButtonClick), for: .touchUpInside)
    }
    
    @objc private func quizAnswerButtonClick() {
        popHandler?(.answer)
    }
    @objc private func reQuizeButtonClik() {
        popHandler?(.allReQuiz)
    }
    @objc private func unMemorizeReQuizButtonClick() {
        popHandler?(.unMemorizeReQuiz)
    }
}
