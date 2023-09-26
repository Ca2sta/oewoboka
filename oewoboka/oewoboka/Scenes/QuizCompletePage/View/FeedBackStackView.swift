//
//  FeedBackStackView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/26.
//

import UIKit

final class FeedBackStackView: UIStackView {
    
    private let quizAnswer: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "exclamationmark.bubble")
        button.text = "퀴즈 정답보기"
        button.type = .center
        return button
    }()
    private let reloadQuizButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "arrow.clockwise")
        button.text = "다시하기"
        button.type = .center
        return button
    }()
    private let noMemoryWorkReloadButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "arrow.clockwise")
        button.text = "모르는 문제 다시 풀기"
        button.type = .center
        return button
    }()
    var noMemoryCount: Int = 0 {
        didSet {
            noMemoryWorkReloadButton.text = "모르는 \(noMemoryCount)문제 다시 풀기"
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
    }
    
    func initStackView() {
        axis = .vertical
        alignment = .fill
        distribution = .fill
        spacing = 16
    }
    
    func addViews() {
        addArrangedSubview(quizAnswer)
        addArrangedSubview(reloadQuizButton)
        addArrangedSubview(noMemoryWorkReloadButton)
    }
}
