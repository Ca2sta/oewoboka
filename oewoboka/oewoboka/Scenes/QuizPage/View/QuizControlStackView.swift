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
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    private let xButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .red
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    private let oButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .systemBlue
        button.layer.borderColor = UIColor.systemBlue.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 20
        button.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return button
    }()
    private let hideButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.setImage(UIImage(systemName: "eye.slash"), for: .selected)
        button.tintColor = .black
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 15
        return button
    }()
    private let mainButtonSize: CGSize
    
    private let viewModel: QuizViewModel


    init(buttonSize: CGSize, viewModel: QuizViewModel) {
        self.mainButtonSize = buttonSize
        self.viewModel = viewModel
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
        buttonSetup()
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
        addArrangedSubview(hideButton)
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
        hideButton.snp.makeConstraints { make in
            make.height.width.equalTo(xButton).dividedBy(1.5)
        }
    }
    
    func buttonSetup() {
        reloadButton.addTarget(self, action: #selector(reload), for: .touchUpInside)
        oButton.addTarget(self, action: #selector(memorize), for: .touchUpInside)
        xButton.addTarget(self, action: #selector(unMemorize), for: .touchUpInside)
        hideButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    @objc func reload() {
        viewModel.reQuizHandler()
    }
    
    @objc func memorize() {
        viewModel.nextHandler?(true)
    }
    
    @objc func unMemorize() {
        viewModel.nextHandler?(false)
    }
    
    @objc func hide() {
        hideButton.isSelected.toggle()
        viewModel.isQuizHidden = hideButton.isSelected
    }
}
