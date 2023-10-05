//
//  VocabularyViewController.swift
//  oewoboka
//
//  Created by APPLE M1 Max on 2023/10/04.
//

import UIKit
import SnapKit

final class VocabularyViewController: UIViewController {
    
    private let topDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let wordTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "단어장 제목"
        view.font = Typography.body1.font
        return view
    }()
    // TextField 란
    private let wordTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "단어장 이름을 입력해 주세요!"
        return textField
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "단어장 설명"
        view.font = Typography.body1.font
        return view
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "단어장 설명을 입력해 주세요!(선택)"
        return textField
    }()
    
    private let bottomDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()

    // '생성' 버튼
    private let addVocablaryButton: DefaultButton = {
        let button = DefaultButton()
        button.isHidden = true
        button.setTitle("생성", for: .normal)
        button.addTarget(self, action: #selector(didTapaddVocablaryButton), for: .touchUpInside)
        return button
    }()
    
    private let vocabularyRepository: VocabularyRepository = VocabularyRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(topDivider)
        view.addSubview(wordTitleLabel)
        view.addSubview(wordTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextField)
        view.addSubview(bottomDivider)
        view.addSubview(addVocablaryButton)
        
        setupConstraints()
        setupNavigation()
        setupTextField()
    }
    
    // TextField 란 설정
    private func setupConstraints() {
        
        topDivider.snp.makeConstraints { make in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
            
        }
        wordTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(topDivider.snp.bottom).offset(Constant.defalutPadding)
            make.left.equalToSuperview().offset(Constant.defalutPadding)
        }
        
        wordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(wordTitleLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(wordTextField.snp.bottom).offset(Constant.defalutPadding)
            make.left.equalToSuperview().offset(Constant.defalutPadding)
        }
        
        descriptionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
        
        bottomDivider.snp.makeConstraints { make in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(1)
        }
   // '생성' 버튼 설정
        addVocablaryButton.snp.makeConstraints { (make) in
            make.top.equalTo(bottomDivider.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalTo(view.safeAreaLayoutGuide).inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    private func setupNavigation() {
        navigationItem.title = "단어장"
    }
    
    private func setupTextField() {
        wordTextField.delegate = self
    }
    
    @objc private func didTapaddVocablaryButton() {
        guard let title = wordTextField.text else { return }
        vocabularyRepository.create(title: title)
        initTextFleid()
        
        self.navigationController?.popViewController(animated: true)
        
    
    }
    
    func buttonHiddenMotion(toggle:Bool){
        UIView.transition(with: addVocablaryButton, duration: 0.5, options: .transitionFlipFromTop, animations: { [weak self] in
            if toggle{
                self?.addVocablaryButton.alpha = 0
            } else {
                self?.addVocablaryButton.alpha = 1
            }
        })
    }
    
    private func initTextFleid() {
        wordTextField.text = ""
        descriptionTextField.text = ""
    }
   
}

extension VocabularyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count == 0 {
            addVocablaryButton.isHidden = true
            buttonHiddenMotion(toggle: addVocablaryButton.isHidden)
        } else if text.count >= 1{
            if addVocablaryButton.isHidden {
                addVocablaryButton.isHidden = false
                buttonHiddenMotion(toggle: addVocablaryButton.isHidden)
            } else {
                addVocablaryButton.isHidden = false
            }
            
            
        }
        
    }
}
