//
//  QuizeMainView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/11/22.
//

import UIKit
import SnapKit

class QuizMainView: UIView {

    lazy var frontCardView: CardView = CardView(viewModel: viewModel)
    lazy var backgroundCardView: CardView = CardView(viewModel: viewModel)
    lazy var quizControlView: QuizControlStackView = QuizControlStackView(buttonSize: CGSize(width: 52.0, height: 52.0), viewModel: viewModel)
    private lazy var dictationStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            dictationTextField
        ])
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 12
        return stackView
    }()
    lazy var dictationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = viewModel.isMeanDictation ? "의미를 작성한 뒤 엔터를 눌러주세요" : "단어를 작성한 뒤 엔터를 눌러주세요"
        textField.font = Typography.title3.font
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let countDownLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title3.font
        label.textColor = .black
        label.text = "00시00분00초"
        return label
    }()
    private lazy var timerSettingView: TimerSettingView = TimerSettingView(viewModel: viewModel)
    var countDownTime: Int = 0 {
        didSet {
            timerSettingView.isHidden = true
            let minute = 60
            if countDownTime <= minute {
                countDownLabel.textColor = .systemRed
            }
            countDownLabel.text = countDownTime.stringFromTime()
        }
    }
    private let margin: CGFloat = 24
    private var currentIndex: Int = 0
    var bottomConstraint: Constraint?
    
    private let viewModel: QuizViewModel
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension QuizMainView {
    func setup() {
        addViews()
        initCardView()
        setupCardView()
        setupAutoLayout()
    }
    
    func addViews() {
        addSubview(backgroundCardView)
        addSubview(frontCardView)
        if viewModel.isWordCard {
            addSubview(quizControlView)
        } else {
            addSubview(dictationStackView)
            if viewModel.isTestType {
                addSubview(timerSettingView)
                addSubview(countDownLabel)
                timerSettingView.backgroundColor = .white
                timerSettingView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
        }
    }
    
    func initCardView() {
        frontCardView.layer.borderWidth = 1
        frontCardView.layer.borderColor = UIColor.black.cgColor
        frontCardView.layer.cornerRadius = 10
        frontCardView.layer.masksToBounds = true
        
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor.black.cgColor
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.masksToBounds = true
    }
    
    func setupCardView() {
        frontCardView.center = backgroundCardView.center
        frontCardView.englishLabel.text = viewModel.currentEnglishLabelText
        frontCardView.koreaLabel.text = viewModel.currentKoreaLabelText
        frontCardView.wordCountLabel.text = viewModel.progressCountText
        
        frontCardView.englishLabel.isHidden = viewModel.isWordLabelHidden
        frontCardView.koreaLabel.isHidden = viewModel.isMeanLabelHidden

        frontCardView.bookMarkButton.isSelected = viewModel.currentWord.isBookmark
        
        guard let nextWord = viewModel.nextWord else {
            backgroundCardView.isHidden = true
            return
        }
        
        backgroundCardView.wordCountLabel.text = viewModel.nextProgressCountText
        backgroundCardView.englishLabel.text = viewModel.nextEnglishText
        backgroundCardView.koreaLabel.text = viewModel.nextKoreaText
        backgroundCardView.bookMarkButton.isSelected = nextWord.isBookmark
    }
    
    func setupAutoLayout() {
        let safeArea = safeAreaLayoutGuide
        var bottomViewHeight = 0.0
        var cardViewBottomConstraint: Constraint? = nil
        
        if viewModel.isTestType {
            countDownLabel.snp.makeConstraints { make in
                make.top.left.equalTo(safeArea).inset(margin)
            }
        }
        
        frontCardView.snp.makeConstraints { make in
            if viewModel.isTestType {
                make.top.equalTo(countDownLabel.snp.bottom).offset(12)
            } else {
                make.top.equalTo(safeArea).inset(margin)
            }
            make.left.right.equalTo(safeArea).inset(margin)
            cardViewBottomConstraint = make.bottom.equalTo(safeArea).constraint
        }
        backgroundCardView.snp.makeConstraints { make in
            make.edges.equalTo(frontCardView)
        }
        
        if viewModel.isWordCard {
            quizControlView.snp.makeConstraints { make in
                make.top.equalTo(frontCardView.snp.bottom).offset(margin)
                make.height.equalTo(52)
                make.left.right.bottom.equalTo(safeArea).inset(margin)
            }
            quizControlView.layoutIfNeeded()
            bottomViewHeight = quizControlView.bounds.height + (margin * 2)
        } else {
            dictationStackView.snp.makeConstraints { make in
                make.left.right.equalTo(safeArea).inset(margin + 4)
                self.bottomConstraint = make.bottom.equalTo(safeArea).inset(margin).constraint
            }
            dictationStackView.layoutIfNeeded()
            bottomViewHeight = dictationStackView.bounds.height + (margin * 2)
        }
        
        cardViewBottomConstraint?.update(inset: bottomViewHeight)
    }
    
    func textFieldInit() {
        dictationTextField.text = ""
    }
    
    func timerReset() {
        timerSettingView.isHidden = false
        countDownLabel.text = "00시00분00초"
        countDownLabel.textColor = .black
    }
}
