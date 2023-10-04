//
//  SelectVocabularyView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/04.
//

import UIKit

final class SelectVocabularyButton: UIButton {
    
    private let selectLabel: UILabel = {
        let label = UILabel()
        label.text = "선택된 단어장"
        label.font = Typography.body3.font
        label.textColor = .systemGray4
        return label
    }()
    
    let vocabularyLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        label.font = Typography.title3.font
        label.textColor = .black
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension SelectVocabularyButton {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    
    func addViews() {
        addSubview(selectLabel)
        addSubview(vocabularyLabel)
    }
    
    func autoLayoutSetup() {
        selectLabel.snp.makeConstraints { make in
            make.top.centerX.equalToSuperview()
        }
        vocabularyLabel.snp.makeConstraints { make in
            make.top.equalTo(selectLabel.snp.bottom)
            make.bottom.centerX.equalToSuperview()
        }
    }
}
