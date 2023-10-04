//
//  WordSaveNotificationView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/04.
//

import UIKit

final class WordSaveNotificationView: UIView {

    let saveWordLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textColor = .black
        return label
    }()
    
    let doneLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textColor = .systemRed
        label.textAlignment = .center
        label.text = "완료"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension WordSaveNotificationView {
    func setup() {
        shadowSetup()
        addViews()
        autoLayoutSetup()
    }
    
    func shadowSetup() {
        layer.borderColor = UIColor.systemGray4.cgColor
        layer.borderWidth = 1
        layer.shadowColor = UIColor.systemGray4.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: 0, height: 2)
    }
    
    func addViews() {
        addSubview(saveWordLabel)
        addSubview(doneLabel)
    }
    
    func autoLayoutSetup() {
        saveWordLabel.snp.makeConstraints { make in
            make.top.left.bottom.equalToSuperview().inset(Constant.defalutPadding)
        }
        doneLabel.snp.makeConstraints { make in
            make.left.equalTo(saveWordLabel.snp.right)
            make.top.right.bottom.equalToSuperview().inset(Constant.defalutPadding)
            make.width.equalToSuperview().dividedBy(6)
        }
    }
}


