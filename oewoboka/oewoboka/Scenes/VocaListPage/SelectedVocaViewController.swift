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
    var data: [WordEntity]?
    
    var currentWordIndex: Int = 0
    
    var words: [WordEntity] = []
    
    var index = 0
    
    let manager = VocabularyRepository.shared
    
    let vocaLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.bigTitle.font
        return label
    }()
    let koreanLabel : UILabel = {
        let label = UILabel()
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
        button.tintColor = .systemPink
        return button
    }()
    let rightButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemPink
        return button
    }()
    let leftButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemPink
        return button
    }()
    let firstButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemPink
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
    
    func bind(data: [WordEntity], index: Int) {
        self.data = data
        self.index = index
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 50, weight: .light)
        let image: UIImage?
        if data[index].isMemorize {
            image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
        } else {
            image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)
        }

        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            isCompleteButton.setImage(image, for: .normal)
        }
        

        vocaLabel.text = data[index].english
        koreanLabel.text = data[index].korea
    }
    
    @objc func firstButtonTapped() {
        print("first")
        guard let data = data else {return}
        index = 0
        bind(data: data, index: index)
    }
    
    @objc func leftButtonTapped() {
        print("left")
        guard let data = data else {return}
        if index > 0{
            index -= 1
            bind(data: data, index: index)
        }
    }
    @objc func rightButtonTapped() {
        print("right")
        guard let data = data else {return}
        if index < data.count - 1{
            index += 1
            bind(data: data, index: index)
        }
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
        
        data[self.index].isMemorize.toggle()
        var image: UIImage?
        if data[self.index].isMemorize {
            image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
        } else {
            image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)
        }
        isCompleteButton.setImage(image, for: .normal)
        manager.update()
    }
}
