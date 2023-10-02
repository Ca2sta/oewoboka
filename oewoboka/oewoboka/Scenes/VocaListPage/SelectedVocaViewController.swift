//
//  SelectedVocaViewController.swift
//  oewoboka
//
//  Created by Lee on 2023/09/27.
//

import UIKit
import SnapKit
class SelectedVocaViewController: UIViewController {
    
    let countLabel: UILabel = {
        let label = UILabel()
        label.text = "1 / 총 단어수"
        label.font = Typography.body2.font
        return label
    }()
    let vocaLabel: UILabel = {
        let label = UILabel()
        label.text = "development"
        label.font = Typography.bigTitle.font
        return label
    }()
    let partLabel : UILabel = {
        let label = UILabel()
        label.text = "명사"
        label.font = Typography.title2.font
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
        isCompleteButton.setImage(UIImage(systemName: "text.justify"), for: .normal)
        hideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        hideButton.addTarget(self, action: #selector(hideButtonTapped), for: .touchUpInside)
        
        leftButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        rightButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        firstButton.setImage(UIImage(systemName: "chevron.left.2"), for: .normal)

    }
    

    func setUpUI() {
        view.addSubview(countLabel)
        view.addSubview(vocaLabel)
        view.addSubview(partLabel)
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
        countLabel.snp.makeConstraints { make in
            make.top.left.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        partLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(10)
            make.width.equalTo(60)
        }
        koreanLabel.snp.makeConstraints {make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        isCompleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(10)
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
    @objc func hideButtonTapped() {
        vocaLabel.isHidden = !vocaLabel.isHidden
        partLabel.isHidden = !partLabel.isHidden
        if vocaLabel.isHidden {
            hideButton.setImage(UIImage(systemName: "eye.slash.fill"), for: .normal)
            
        } else {
            hideButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }
    }
}
