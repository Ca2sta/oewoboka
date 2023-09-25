//
//  QuizControlStackView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class QuizControlStackView: UIStackView {
    private let reloadButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    private let xButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .red
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    private let oButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    private let showButton: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(systemName: "eye"), for: .normal)
        button.setBackgroundImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    private let mainButtonSize: CGSize


    init(buttonSize: CGSize) {
        self.mainButtonSize = buttonSize
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension QuizControlStackView {
    func setup() {
        initSetup()
        addViews()
        autoLayoutSetup()
    }
    
    func initSetup() {
        axis = .horizontal
        alignment = .center
        distribution = .equalSpacing
    }
    
    func addViews() {
        addArrangedSubview(reloadButton)
        addArrangedSubview(xButton)
        addArrangedSubview(oButton)
        addArrangedSubview(showButton)
    }
    
    func autoLayoutSetup() {
        xButton.snp.makeConstraints { make in
            make.height.equalTo(mainButtonSize.height)
            make.width.equalTo(mainButtonSize.width)
        }
        oButton.snp.makeConstraints { make in
            make.height.width.equalTo(xButton)
        }
        reloadButton.snp.makeConstraints { make in
            make.height.width.equalTo(xButton).dividedBy(1.5)
        }
        showButton.snp.makeConstraints { make in
            make.height.width.equalTo(xButton).dividedBy(1.5)
        }
    }
}
