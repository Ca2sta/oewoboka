//
//  QuizSettingView.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/27.
//

import UIKit
import SnapKit

final class QuizSettingView: UIView {
    
    enum QuizSettingType {
        case range
        case type
    }

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        label.textColor = .systemGray
        return label
    }()
    
    let rangeButton: DefaultButton = {
        let button = DefaultButton()
        button.image = UIImage(systemName: "person")
        button.text = "단어장 선택"
        button.type = .rightImage(UIImage(systemName: "person"))
        return button
    }()
    
    private let rangeDivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let typeCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let width = Constant.screenWidth - (Constant.defalutPadding * 2)
        flowLayout.itemSize = CGSize(width: width, height: Constant.screenHeight * 0.05)
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        return view
    }()
    
    private let type: QuizSettingType
    
    
    init(title:String, description:String, type: QuizSettingType) {
        self.type = type
        super.init(frame: CGRect.zero)
        self.titleLabel.text = title
        self.descriptionLabel.text = description
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension QuizSettingView {
    // MARK: - SetUp

    func setUp(){
        setUpRangeLabel()
        setUpRangeDescription()
        
        switch type {
            case .range :
                setUpRangeButton()
                setUpRangeDivider()
            case .type :
                setUpCollectionView()
                setUpCollectionDivider()
        }

    }
    
    func setUpRangeLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(Constant.defalutPadding)
        }
    }
    
    func setUpRangeDescription() {
        self.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalTo(titleLabel)
        }
    }
    
    func setUpRangeButton() {
        self.addSubview(rangeButton)
        rangeButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalTo(descriptionLabel)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    func setUpRangeDivider() {
        self.addSubview(rangeDivider)
        rangeDivider.snp.makeConstraints { make in
            make.top.equalTo(rangeButton.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setUpCollectionView() {
        self.addSubview(typeCollectionView)
        typeCollectionView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalToSuperview()
            make.height.equalTo(Constant.screenHeight * 0.25)
        }
    }
    
    func setUpCollectionDivider() {
        self.addSubview(rangeDivider)
        rangeDivider.snp.makeConstraints { make in
            make.top.equalTo(typeCollectionView.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}
