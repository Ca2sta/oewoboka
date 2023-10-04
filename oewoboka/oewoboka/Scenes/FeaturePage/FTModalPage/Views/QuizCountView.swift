//
//  QuizCountView.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/28.
//

import UIKit
import SnapKit

final class QuizCountView: UIView {
    
    
    lazy var title: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
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
    
    lazy var plusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
    lazy var minusButton: UIButton = {
        let button = UIButton()
        button.tintColor = .black
        return button
    }()
    
    lazy var countLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.textColor = .systemPink
        label.textAlignment = .center
        return label
    }()
    
    lazy var sliderView: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = .systemPink
        slider.minimumTrackTintColor = .systemPink
        return slider
    }()
    
    weak var buttonDelegate: ViewHasButton?
    
    weak var sliderDelegate: ViewHasSlider?
    
    init(viewModel: FTOPViewModel) {
        super.init(frame: CGRect.zero)
        setUp()
        bind(viewModel: viewModel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension QuizCountView {
    // MARK: - bind
    func bind(viewModel: FTOPViewModel) {
        
        title.text = viewModel.countViewTitle
        plusButton.setImage(viewModel.countViewPlusBTImage, for: .normal)
        minusButton.setImage(viewModel.countViewMinusImage, for: .normal)
        countLabel.text = "\(viewModel.count)개"
        sliderView.value = (Float(viewModel.count.value) / 100)
        
        viewModel.count.bind { value in
            self.countLabel.text = "\(value)개"
            self.sliderView.value = (Float(value) / 100)
        }
    }
    // MARK: - SetUp
    func setUp() {
        setUpTitle()
        setUpStackView()
        setUpSlider()
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
            make.centerY.equalTo(title.snp.centerY)
            make.right.equalToSuperview().inset(Constant.defalutPadding)
            make.height.equalTo(Constant.screenHeight * 0.03)
        }
        stackView.addArrangedSubview(minusButton)
        minusButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenHeight * 0.03)
        }
        minusButton.addTarget(self, action: #selector(didTappedCountButton(_:)), for: .touchUpInside)
        stackView.addArrangedSubview(countLabel)
        countLabel.snp.makeConstraints { make in
            make.width.equalTo(Constant.screenHeight * 0.07)
        }
        stackView.addArrangedSubview(plusButton)
        plusButton.snp.makeConstraints { make in
            make.height.width.equalTo(Constant.screenHeight * 0.03)
        }
        plusButton.addTarget(self, action: #selector(didTappedCountButton(_:)), for: .touchUpInside)
    }
    
    func setUpSlider() {
        self.addSubview(sliderView)
        sliderView.snp.makeConstraints { make in
            make.top.equalTo(title.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.equalToSuperview().inset(Constant.defalutPadding)
            make.height.equalTo(stackView)
        }
        sliderView.addTarget(self, action: #selector(didSlideSlider(_ :)), for: .valueChanged)
    }
    
    func setUpDivider() {
        self.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(sliderView.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
    }
}

private extension QuizCountView {
    // MARK: - ButtonTappedMethod
    
    @objc func didTappedCountButton(_ button: UIButton) {
        buttonDelegate?.didTappedButton(button: button)
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        sliderDelegate?.didSlideSlider(slider)
    }
}


