//
//  FeatureCollectionViewCell.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import UIKit
import SnapKit

final class FeatureCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeatureCollectionViewCell"
    
    lazy var imageView = UIImageView()
    
    private let titleLabel = UILabel()
    
    private let descriptionLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension FeatureCollectionViewCell {
    // MARK: - SetUp

    func setUp(){
        setUpContentView()
        setUpImageView()
        setUpTitleLabel()
        setUpDescriptionLabel()
    }
    
    func setUpContentView() {
        contentView.layer.cornerRadius = 20
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray.cgColor
    }
    
    func setUpImageView() {
        contentView.addSubview(imageView)
        imageView.tintColor = .systemGray
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenWidth * 0.2)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.1)
        }
    }
    
    func setUpTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.font = Typography.title2Medium.font
        titleLabel.textAlignment = .center
        titleLabel.textColor = .systemPink
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalToSuperview()
        }
    }
    
    func setUpDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.font = Typography.body2.font
        descriptionLabel.textAlignment = .center
        descriptionLabel.textColor = .systemPink
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalToSuperview()
        }
    }
}

extension FeatureCollectionViewCell {
    // MARK: - Bind

    func bind(data:FeatureCellModel) {
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        imageView.image = data.image
    }
}
