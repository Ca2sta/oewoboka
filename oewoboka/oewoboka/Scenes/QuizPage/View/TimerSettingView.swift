//
//  TimerSettingView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/05.
//

import UIKit

final class TimerSettingView: UIStackView {

    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .countDownTimer
        datePicker.preferredDatePickerStyle = .wheels
        return datePicker
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let backButton: UIButton = {
        let button = UIButton()
        button.setTitle("뒤로가기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Typography.body1.font
        return button
    }()
    private let startButton: UIButton = {
        let button = UIButton()
        button.setTitle("시작하기", for: .normal)
        button.setTitleColor(.systemPink, for: .normal)
        button.titleLabel?.font = Typography.body1.font
        return button
    }()
    
    private let viewModel: QuizViewModel
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension TimerSettingView {
    func setup() {
        initStackView()
        addViews()
        buttonSetup()
    }
    
    func initStackView() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.gray.cgColor
        layer.cornerRadius = 10
        axis = .vertical
        alignment = .fill
        distribution = .fillProportionally
    }
    
    func addViews() {
        addArrangedSubview(datePicker)
        addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(backButton)
        buttonStackView.addArrangedSubview(startButton)
    }
    
    func buttonSetup() {
        backButton.addTarget(self, action: #selector(backButtonClick), for: .touchUpInside)
        startButton.addTarget(self, action: #selector(startButtonClick), for: .touchUpInside)
    }
    
    @objc func backButtonClick() {
        viewModel.dismissHandler()
    }
    
    @objc func startButtonClick() {
        viewModel.dateObservable.value = datePicker.countDownDuration
    }
}
