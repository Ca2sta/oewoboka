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

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.text = type == .range ? viewModel.rangeViewTitle : viewModel.typeViewTitle
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        label.textColor = .systemGray
        label.text = type == .range ? viewModel.rangeViewDescription : viewModel.typeViewDescription
        return label
    }()
    
    lazy var rangeButton: DefaultButton = {
        let button = DefaultButton()
        button.image = viewModel.rangeBTLeftImage
        button.text = viewModel.rangeBTtitle
        button.type = .rightImage(viewModel.rangeBTRightImage)
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
    
    private let viewModel: FTOPViewModel
    
    weak var buttonDelegate: ViewHasButton?
    
    init(type: QuizSettingType, viewModel: FTOPViewModel ) {
        self.viewModel = viewModel
        self.type = type
        super.init(frame: CGRect.zero)
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
        rangeButton.addTarget(self, action: #selector(didTappedRangeButton(_:)), for: .touchUpInside)
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

private extension QuizSettingView {
    @objc func didTappedRangeButton(_ button: UIButton) {
        buttonDelegate?.didTappedButton(button: button)
    }
}
