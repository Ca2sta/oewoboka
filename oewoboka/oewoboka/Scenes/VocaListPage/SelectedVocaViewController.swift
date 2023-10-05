//
//  SelectedVocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/27.
//

import UIKit
import SnapKit
import CoreData

class SelectedVocaViewController: UIViewController {
    var buttonState = 2
    var data: WordEntity?
    var currentWordIndex: Int = 0
    var words: [WordEntity] = []
    let vocaLabel: UILabel = {
        let label = UILabel()
        label.text = "development"
        label.font = Typography.bigTitle.font
        return label
    }()
    let koreanLabel : UILabel = {
        let label = UILabel()
        label.text = "발달,성장,개발"
        label.font = Typography.title2.font
        return label
    }()
    let bottomSheetView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray3
        return view
    }()
    let isCompleteButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    let rightButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    let leftButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    let firstButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    let hideButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .black
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        view.backgroundColor = .systemBackground
        
        hideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        firstButton.setImage(UIImage(systemName: "chevron.left.2"), for: .normal)
        
        isCompleteButton.addTarget(self, action: #selector(isCompleteButtonTapped), for: .touchUpInside)
        firstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        leftButton.addTarget(self, action: #selector(leftButtonTapped), for: .touchUpInside)
        rightButton.addTarget(self, action: #selector(rightButtonTapped), for: .touchUpInside)

    }
    
    func bind(data: WordEntity) {
        self.data = data
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image: UIImage?
        if data.isMemorize {
            image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
        } else {
            image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)
        }
        
        isCompleteButton.setImage(image, for: .normal)
        
        vocaLabel.text = data.english
        koreanLabel.text = data.korea
    }

    func setUpUI() {
        view.addSubview(vocaLabel)
        view.addSubview(koreanLabel)
        view.addSubview(bottomSheetView)
        view.addSubview(isCompleteButton)
        bottomSheetView.addSubview(hideButton)
        bottomSheetView.addSubview(leftButton)
        bottomSheetView.addSubview(rightButton)
        bottomSheetView.addSubview(firstButton)

        
        vocaLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-40)
        }
        koreanLabel.snp.makeConstraints {make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        isCompleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        bottomSheetView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(50)
        }
        firstButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(130)
            make.centerY.equalToSuperview()
        }
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-130)
            make.centerY.equalToSuperview()
        }
        hideButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-30)
            make.centerY.equalToSuperview()
        }
    }
    @objc func firstButtonTapped() {
        print("first")
    }
    @objc func leftButtonTapped() {
        print("left")
//        if currentWordIndex > 0 {
//            currentWordIndex -= 1
//            if currentWordIndex < words.count, let word = words[currentWordIndex] {
//                bind(data: word)
//            }
//        }
    }
    @objc func rightButtonTapped() {
        print("right")
//        if currentWordIndex < words.count - 1 {
//            currentWordIndex += 1
//            if currentWordIndex >= 0, let word = words[currentWordIndex] {
//                bind(data: word)
//            }
//        }
    }
    
    @objc func hideButtonTapped() {
        vocaLabel.isHidden = !vocaLabel.isHidden
        if vocaLabel.isHidden {
            hideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        } else {
            hideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
    
    @objc func isCompleteButtonTapped() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        guard let data = data else { return }
        
        switch buttonState {
        case 1:
            let image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
            isCompleteButton.setImage(image, for: .normal)
            data.isMemorize = true
            print(data.isMemorize)

            buttonState = 2
        case 2:
            let image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)
            isCompleteButton.setImage(image, for: .normal)
            data.isMemorize = false
            print(data.isMemorize)
            buttonState = 1
        default:
            break
        }
    }
}
