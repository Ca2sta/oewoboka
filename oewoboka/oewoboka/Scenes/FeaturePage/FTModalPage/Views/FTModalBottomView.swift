//
//  FTModalBottomView.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/27.
//

import UIKit
import SnapKit

final class FTModalBottomView: UIView {

    private let startButton: DefaultButton = {
        let button = DefaultButton()
        button.text = "퀴즈 시작"
        button.image = UIImage(systemName: "person")
        button.type = .center
        return button
    }()
    
    private let startBTdivider: UIView = {
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

private extension FTModalBottomView {
    
    // MARK: - SetUp

    func setUp() {
        setUpStartButton()
        setUpStartBTdivider()
        
    }
    
    func setUpStartButton() {
        self.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.bottom.left.right.equalToSuperview().inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    func setUpStartBTdivider() {
        self.addSubview(startBTdivider)
        startBTdivider.snp.makeConstraints { make in
            make.bottom.equalTo(startButton.snp.top).offset(-Constant.defalutPadding)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
            make.top.equalToSuperview()
        }
    }
}
