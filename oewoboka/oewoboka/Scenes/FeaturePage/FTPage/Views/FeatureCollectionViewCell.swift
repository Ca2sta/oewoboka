//
//  FeatureCollectionViewCell.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import UIKit
import SnapKit

final class FeatureCollectionViewCell: UICollectionViewCell {
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.tintColor = .systemGray
        return view
    }()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.title2Medium.font
        view.textAlignment = .center
        view.textColor = .systemGray
        return view
    }()
    
    private let descriptionLabel: UILabel = {
        let view = UILabel()
        view.font = Typography.body2.font
        view.textAlignment = .center
        view.textColor = .systemGray
        return view
    }()
    
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
        imageView.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenWidth * 0.2)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(Constant.screenHeight * 0.1)
        }
    }
    
    func setUpTitleLabel() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalToSuperview()
        }
    }
    
    func setUpDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
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

extension FeatureCollectionViewCell {
    // MARK: - colorLoad

    func colorLoad(color: UIColor) {
        contentView.layer.borderColor = color.cgColor
        titleLabel.textColor = color
        descriptionLabel.textColor = color
        imageView.tintColor = color
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        get { String(describing: type(of: self)) }
    }
}
