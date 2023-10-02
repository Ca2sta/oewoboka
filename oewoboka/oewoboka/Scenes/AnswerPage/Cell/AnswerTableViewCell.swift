//
//  AnswerTableViewCell.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/02.
//

import UIKit
import SnapKit

class AnswerTableViewCell: UITableViewCell {
    static let identifier: String = "\(AnswerTableViewCell.self)"
    private let topView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 0
        return stackView
    }()
    let numberLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body3.font
        label.textColor = .systemGray4
        return label
    }()
    let vocabularyTitleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body3.font
        label.textColor = .systemGray4
        return label
    }()
    let bookMarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.tintColor = button.isSelected ? .red : .black
        return button
    }()
    private let wordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    let englishWordLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.textColor = .red
        return label
    }()
    let koreaWordLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        label.textColor = .black
        return label
    }()
    var wordBookmarkUpdate: ((Bool) -> Void)?
    

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: UI Init
private extension AnswerTableViewCell {
    func setup() {
        addView()
        buttonSetup()
        autoLayoutSetup()
    }
    
    func addView() {
        contentView.addSubview(topView)
        contentView.addSubview(wordStackView)
        topView.addArrangedSubview(numberLabel)
        topView.addArrangedSubview(vocabularyTitleLabel)
        topView.addArrangedSubview(bookMarkButton)
        wordStackView.addArrangedSubview(englishWordLabel)
        wordStackView.addArrangedSubview(koreaWordLabel)
    }
    
    func buttonSetup() {
        bookMarkButton.addTarget(self, action: #selector(bookmarkButtonClick), for: .touchUpInside)
    }
    
    @objc func bookmarkButtonClick() {
        bookMarkButton.isSelected.toggle()
        wordBookmarkUpdate?(bookMarkButton.isSelected)
    }
    
    func autoLayoutSetup() {
        numberLabel.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        bookMarkButton.snp.makeConstraints { make in
            make.width.height.equalTo(32)
        }
        topView.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.left.right.equalTo(contentView).inset(8)
        }
        wordStackView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(contentView.snp.bottom).inset(12)
            make.left.equalTo(contentView).inset(8)
        }
    }
}
