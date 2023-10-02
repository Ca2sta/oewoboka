//
//  BottomView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/02.
//

import UIKit

class BottomView: UIStackView {
    
    private let unBookMarkButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "bookmark.slash")
        button.text = "맞은 단어를 마크 해제"
        return button
    }()
    private let bookMarkButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "bookmark")
        button.text = "틀린 단어를 마크"
        return button
    }()
    private let topLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension BottomView {
    func setup() {
        stackViewInit()
        addViews()
        autoLayoutSetup()
    }
    
    func stackViewInit() {
        axis = .vertical
        alignment = .fill
        distribution = .fillEqually
        spacing = 12
        isLayoutMarginsRelativeArrangement = true
        layoutMargins = UIEdgeInsets(top: spacing, left: 16, bottom: 0, right: 16)
    }
    
    func addViews() {
        addArrangedSubview(unBookMarkButton)
        addArrangedSubview(bookMarkButton)
        addSubview(topLineView)
    }
    
    func autoLayoutSetup() {
        topLineView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
