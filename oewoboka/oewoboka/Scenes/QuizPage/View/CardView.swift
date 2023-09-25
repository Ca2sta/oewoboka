//
//  CardView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit
import SnapKit

final class CardView: UIView {
    private let wordCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .lightGray
        return label
    }()
    private let cardStateStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
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
        button.setTitle("?", for: .normal)
        button.setTitle("!", for: .selected)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    private let wordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 12
        return stackView
    }()
    let englishLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    let koreaLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let inset: CGFloat = 24

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
        addViews()
        autoLayoutSetup()
        countLabelSetup()
        buttonSetup()
    }
    
    func addViews() {
        addSubview(wordCountLabel)
        addSubview(cardStateStackView)
        cardStateStackView.addArrangedSubview(bookMarkButton)
        cardStateStackView.addArrangedSubview(stateButton)
        addSubview(wordStackView)
        wordStackView.addArrangedSubview(englishLabel)
        wordStackView.addArrangedSubview(koreaLabel)
    }
    
    func autoLayoutSetup() {
        wordCountLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(inset)
        }
        cardStateStackView.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(inset)
        }
        wordStackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    func buttonSetup() {
        bookMarkButton.addTarget(self, action: #selector(bookMarkClick), for: .touchUpInside)
        stateButton.addTarget(self, action: #selector(stateButtonClick), for: .touchUpInside)
    }
    
    func countLabelSetup() {
        wordCountLabel.text = "1/6"
    }
    
    @objc func bookMarkClick() {
        bookMarkButton.isSelected.toggle()
    }
    
    @objc func stateButtonClick() {
        stateButton.isSelected.toggle()
    }
}
