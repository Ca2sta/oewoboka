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
    private let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.tintColor = .lightGray
        return button
    }()
    private let stateButton: UIButton = {
        let button = UIButton()
        let contentVerticalInset: CGFloat = 3
        let contentHorzontalInset: CGFloat = contentVerticalInset * 2
        button.contentEdgeInsets = UIEdgeInsets(top: contentVerticalInset, left: contentHorzontalInset, bottom: contentVerticalInset, right: contentHorzontalInset)
        button.setImage(UIImage(systemName: "questionmark"), for: .normal)
        button.setImage(UIImage(systemName: "exclamationmark"), for: .selected)
        button.tintColor = .black
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
        label.font = Typography.title3.font
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    let englishTextField: UITextField = {
        let textField = UITextField()
        textField.font = Typography.title3.font
        textField.textColor = .black
        textField.textAlignment = .center
        textField.placeholder = "영단어 작성"
        return textField
    }()
    let koreaLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()
    let koreaTextField: UITextField = {
        let textField = UITextField()
        textField.font = Typography.body1.font
        textField.textColor = .black
        textField.textAlignment = .center
        textField.placeholder = "의미 작성"
        return textField
    }()
    
    private let inset: CGFloat = 24
    var quizType: QuizType = .training {
        didSet {
            addViews()
            autoLayoutSetup()
        }
    }

    init() {
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
        buttonSetup()
    }
    
    func addViews() {
        addSubview(topLineStackView)
        topLineStackView.addArrangedSubview(wordCountLabel)
        topLineStackView.addArrangedSubview(cardStateStackView)
        cardStateStackView.addArrangedSubview(bookMarkButton)
        cardStateStackView.addArrangedSubview(stateButton)
        addSubview(wordStackView)
        switch quizType {
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
        
        let stateButtonWidthSize = 26
        
        stateButton.snp.makeConstraints { make in
            make.width.equalTo(stateButtonWidthSize)
        }

        wordStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
//    func quizTypeSetup() {
//        switch quizType {
//        case .training:
//            break
//        case .wordDictation:
//            englishLabel.isHidden = true
//        case .meanDictation:
//            koreaLabel.isHidden = true
//        case .test:
//            print("test")
//        }
//    }
    
    func buttonSetup() {
        bookMarkButton.addTarget(self, action: #selector(bookMarkClick), for: .touchUpInside)
        stateButton.addTarget(self, action: #selector(stateButtonClick), for: .touchUpInside)
    }
    
    @objc func bookMarkClick() {
        bookMarkButton.isSelected.toggle()
    }
    
    @objc func stateButtonClick() {
        stateButton.isSelected.toggle()
    }
}
