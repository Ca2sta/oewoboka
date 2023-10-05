//
//  CardView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit
import SnapKit

final class CardView: UIView {
    
    let topLineStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    let wordCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    private let cardStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.tintColor = .lightGray
        return button
    }()
    private let wordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    let englishLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title2.font
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    let koreaLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    var updateBookmarkHandler: ((Bool)->Void)?
    private let viewModel: QuizViewModel
    
    private let inset: CGFloat = 24

    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CardView {
    func setup() {
        backgroundColor = .white
        addViews()
        autoLayoutSetup()
        buttonSetup()
    }
    
    func addViews() {
        addSubview(topLineStackView)
        topLineStackView.addArrangedSubview(wordCountLabel)
        topLineStackView.addArrangedSubview(cardStateStackView)
        cardStateStackView.addArrangedSubview(bookMarkButton)
        addSubview(wordStackView)
        switch viewModel.quizType {
        case .training:
            wordStackView.addArrangedSubview(englishLabel)
            wordStackView.addArrangedSubview(koreaLabel)
        case .wordDictation:
            wordStackView.addArrangedSubview(englishLabel)
            wordStackView.addArrangedSubview(koreaLabel)
            englishLabel.text = ""
        case .meanDictation:
            wordStackView.addArrangedSubview(englishLabel)
            wordStackView.addArrangedSubview(koreaLabel)
            koreaLabel.text = ""
        case .test:
            wordStackView.addArrangedSubview(englishLabel)
            wordStackView.addArrangedSubview(koreaLabel)
        }
    }
    
    func autoLayoutSetup() {
        topLineStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview().inset(inset)
        }

        wordStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func buttonSetup() {
        bookMarkButton.addTarget(self, action: #selector(bookMarkClick), for: .touchUpInside)
    }
    
    @objc func bookMarkClick() {
        bookMarkButton.isSelected.toggle()
        viewModel.currentWord.isBookmark = bookMarkButton.isSelected
    }
}
