//
//  TopView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/02.
//

import UIKit
import SnapKit

class TopView: UIStackView {
    
    private let spacerView: UIView = UIView()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    private let closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let bottomLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    init(title: String) {
        super.init(frame: .zero)
        titleLabel.text = title
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TopView {
    func setup() {
        stackViewInit()
        addViews()
        autoLayoutSetup()
    }
    
    func stackViewInit() {
        axis = .horizontal
        alignment = .fill
        distribution = .fill
    }
    
    func addViews() {
        addArrangedSubview(spacerView)
        addArrangedSubview(titleLabel)
        addArrangedSubview(closeButton)
        addSubview(bottomLineView)
    }
    
    func autoLayoutSetup() {
        spacerView.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        closeButton.snp.makeConstraints { make in
            make.width.height.equalTo(44)
        }
        bottomLineView.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
