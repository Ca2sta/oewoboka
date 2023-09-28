//
//  QuizCountView.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/28.
//

import UIKit
import SnapKit

final class QuizCountView: UIView {


    private let title: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.text = "문제 개수 제한"
        return label
    }()
    
    private let stackView: UIStackView = {
        let view = UIStackView()
        view.spacing = Constant.defalutPadding
        view.distribution = .equalSpacing
        return view
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    let plusButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.screenHeight * 0.03)
        let image = UIImage(systemName: "plus.circle", withConfiguration: imageConfig)
        button.tintColor = .black
        button.setImage(image, for: .normal)
        return button
    }()
    
    let minusButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.screenHeight * 0.03)
        let image = UIImage(systemName: "minus.circle", withConfiguration: imageConfig)
        button.tintColor = .black
        button.setImage(image, for: .normal)
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.textColor = .systemPink
        label.text = "\(count)개"
        label.textAlignment = .center
        return label
    }()
    
    var count = 10 {
        didSet {
            countLabel.text = "\(count)개"
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension QuizCountView {
    // MARK: - SetUp
    func setUp() {
        setUpTitle()
        setUpStackView()
        setUpDivider()
    }
    
    func setUpTitle() {
        self.addSubview(title)
        title.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(Constant.defalutPadding)
        }
    }
    
    func setUpStackView() {
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.03)
        }
        stackView.addArrangedSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenHeight * 0.03)
        }
        stackView.addArrangedSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(Constant.screenHeight * 0.05)
        }
        stackView.addArrangedSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenHeight * 0.03)
        }
    }
    
    func setUpDivider() {
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }

}

