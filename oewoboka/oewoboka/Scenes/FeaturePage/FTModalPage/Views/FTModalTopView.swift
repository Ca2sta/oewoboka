//
//  FTModalTopView.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/27.
//

import UIKit
import SnapKit

final class FTModalTopView: UIView {

    let titleLabel: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = Typography.title2Medium.font
        return view
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.imageView?.tintColor = .black
        return button
    }()
    
    private let titledivider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FTModalTopView {
    
    func setUp() {
        setUpTitleLabel()
        setUpBackButton()
        setUpDivider()
    }
    
    func setUpTitleLabel() {
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constant.defalutPadding / 2)
            make.centerX.equalToSuperview()
        }
    }
    
    func setUpBackButton() {
        self.addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.top)
            make.right.equalToSuperview().inset(Constant.defalutPadding)
            make.width.height.equalTo(titleLabel.snp.height)
        }
    }
    
    func setUpDivider() {
        self.addSubview(titledivider)
        titledivider.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(Constant.defalutPadding / 2)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
