//
//  VocabularyViewController.swift
//  oewoboka
//
//  Created by APPLE M1 Max on 2023/10/04.
//

import UIKit
import SnapKit

final class VocabularyViewController: UIViewController {
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
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
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.backgroundColor = .white
        textField.placeholder = "단어장 설명을 입력해 주세요!(선택)"
        return textField
    }()

    // '생성' 버튼
    private let addVocablaryButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("생성", for: .normal)
        button.addTarget(self, action: #selector(didTapaddVocablaryButton), for: .touchUpInside)
        return button
    }()
    
    private let vocabularyRepository: VocabularyRepository = VocabularyRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        view.addSubview(wordTextField)
        view.addSubview(descriptionTextField)
        view.addSubview(addVocablaryButton)
        
        setupConstraints()
        setupNavigation()
        setupTextField()
    }
    
    // TextField 란 설정
    private func setupConstraints() {
        wordTextField.snp.makeConstraints { (make) in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
        
        descriptionTextField.snp.makeConstraints { (make) in
            make.top.equalTo(wordTextField.snp.bottom).offset(20)
            make.left.equalTo(view).offset(20)
            make.right.equalTo(view).offset(-20)
            make.height.equalTo(40)
        }
   // '생성' 버튼 설정
        addVocablaryButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextField.snp.bottom).offset(20)
            make.centerX.equalTo(view)
        }
    }
    
    private func setupNavigation() {
        navigationController?.title = "단어장"
        let rightButton = UIBarButtonItem(title: "생성", style: .done, target: self, action: #selector(didTapaddVocablaryButton))
        rightButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = rightButton
        navigationItem.rightBarButtonItem?.isEnabled = false
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
    
    private func initTextFleid() {
        wordTextField.text = ""
        descriptionTextField.text = ""
    }
   
}

extension VocabularyViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let text = textField.text else { return }
        navigationItem.rightBarButtonItem?.isEnabled = !text.isEmpty
    }
}
