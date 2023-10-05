//
//  QuizViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import Foundation
import UIKit
import SnapKit

final class QuizViewController: UIViewController {
    
    private let frontCardView: CardView = CardView()
    private let backgroundCardView: CardView = CardView()
    private let quizControlView: QuizControlStackView = QuizControlStackView(buttonSize: CGSize(width: 52.0, height: 52.0))
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
    private lazy var dictationTextField: UITextField = {
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
    private var timer = Timer()
    private var countDownTime: Int = 0 {
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
    private var bottomConstraint: Constraint?
    
    let vocabularyList: [VocabularyEntity]
    
    private var isQuizHidden: Bool = false
    private var quizResultWords: [WordEntity] = []
    private var words: [WordEntity] = []
    private let repository = VocabularyRepository.shared
    private let viewModel: QuizViewModel = QuizViewModel()
    
    init(quizData: QuizSettingData) {
        self.vocabularyList = quizData.selectedVocabulary.isEmpty ? repository.allFetch() : quizData.selectedVocabulary
        self.viewModel.featureType = quizData.featureType
        self.viewModel.quizType = quizData.quizType
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = .white
        quizTypeSetup()
        view.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}

private extension QuizViewController {
    func setup() {
        addViews()
        navigationSetup()
        initCardView()
        cardViewSetup(index: currentIndex)
        textFieldSetup()
        autoLayoutSetup()
        bind()
    }
    
    func addViews() {
        view.addSubview(backgroundCardView)
        view.addSubview(frontCardView)
        if viewModel.isWordCard {
            view.addSubview(quizControlView)
        } else {
            view.addSubview(dictationStackView)
            if viewModel.isTestType {
                view.addSubview(timerSettingView)
                view.addSubview(countDownLabel)
                timerSettingView.backgroundColor = .white
                timerSettingView.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
        }
    }
    
    func navigationSetup() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popViewController))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.title = "단어보기"
    }
    
    @objc private func popViewController() {
        dismiss(animated: true)
    }
    
    func initCardView() {
        
        let vocabularyWords = vocabularyList
                                .compactMap({ $0.words?.array as? [WordEntity] })
                                .flatMap({ $0 })
        words = vocabularyWords
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cardMove(sender:)))
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss(sender:)))
        frontCardView.isUserInteractionEnabled = true
        frontCardView.addGestureRecognizer(panGesture)
        frontCardView.addGestureRecognizer(tapGesture)
        
        frontCardView.layer.borderWidth = 1
        frontCardView.layer.borderColor = UIColor.black.cgColor
        frontCardView.layer.cornerRadius = 10
        frontCardView.layer.masksToBounds = true
        
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor.black.cgColor
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.masksToBounds = true
    }
    
    @objc func keyboardDismiss(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func cardViewSetup(index: Int) {
        guard index >= 0 else { return }
        guard index < words.count else {
            navigationPushQuizCompletePage()
            return
        }
        let word = words[index]
        let countText = "\(index + 1) / \(words.count)"
        frontCardView.englishLabel.text = word.english
        frontCardView.koreaLabel.text = word.korea
        frontCardView.wordCountLabel.text = countText

        frontCardView.bookMarkButton.isSelected = word.isBookmark
        frontCardView.updateBookmarkHandler = { [weak self] isBookmark in
            guard let self else { return }
            self.words[index].isBookmark = isBookmark
        }
        
        if viewModel.isDictation || viewModel.isTestType {
            if viewModel.isMeanDictation {
                frontCardView.koreaLabel.text = ""
            } else if viewModel.isWordDictation {
                frontCardView.englishLabel.text = ""
            }
        } else if viewModel.isWordCard{
            if viewModel.isMeanDictation {
                frontCardView.koreaLabel.isHidden = isQuizHidden
            } else if viewModel.isWordDictation {
                frontCardView.englishLabel.isHidden = isQuizHidden
            }
        }
        
        let nextIndex = index + 1
        guard nextIndex < words.count else {
            backgroundCardView.isHidden = true
            return
        }
        
        let nextWord = words[nextIndex]
        let nextCountText = "\(nextIndex + 1) / \(words.count)"
        backgroundCardView.wordCountLabel.text = nextCountText
        backgroundCardView.englishLabel.text = nextWord.english
        backgroundCardView.koreaLabel.text = nextWord.korea
        backgroundCardView.bookMarkButton.isSelected = nextWord.isBookmark
        
        if viewModel.isDictation || viewModel.isTestType {
            if viewModel.isMeanDictation {
                backgroundCardView.koreaLabel.text = ""
            } else if viewModel.isWordDictation {
                backgroundCardView.englishLabel.text = ""
            }
        } else if viewModel.isWordCard {
            if viewModel.isMeanDictation {
                backgroundCardView.koreaLabel.isHidden = isQuizHidden
            } else if viewModel.isWordDictation {
                backgroundCardView.englishLabel.isHidden = isQuizHidden
            }
        }
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
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
    
    func quizTypeSetup() {
        frontCardView.quizType = viewModel.quizType
        backgroundCardView.quizType = viewModel.quizType
    }
    
    func textFieldSetup() {
        dictationTextField.delegate = self
        dictationTextField.becomeFirstResponder()
    }
    
    func keyboardReturn() {
        switch viewModel.quizType {
        case .meanDictation:
            if words[currentIndex].korea == dictationTextField.text {
                cardMoveAnimation(moveView: frontCardView, isMemorize: true)
            }
        case .wordDictation:
            if words[currentIndex].english == dictationTextField.text {
                cardMoveAnimation(moveView: frontCardView, isMemorize: true)
            }
        default:
            break
        }
    }
    
    func navigationPushQuizCompletePage() {
        let vc = QuizCompleteViewController(viewModel: viewModel, words: quizResultWords)
        vc.popCompletion = { [weak self] words in
            guard let self else { return }
            if let words {
                self.words = words
            }
            self.backgroundCardView.isHidden = false
            self.quizResultWords = []
            self.currentIndex = 0
            self.cardViewSetup(index: currentIndex)
            if self.viewModel.isTestType {
                timerReset()
            }
        }
        navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func cardMove(sender: UIPanGestureRecognizer) {
        guard let moveView = sender.view else { return }
        let point = sender.translation(in: view)
        moveView.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
                        
        if sender.state == .ended {
            if moveView.center.x < 100 {
                cardMoveAnimation(moveView: moveView, isMemorize: false)
            } else if moveView.center.x > (view.bounds.width - 100) {
                cardMoveAnimation(moveView: moveView, isMemorize: true)
            } else {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = self.backgroundCardView.center
                }
            }
        }
    }
    
    private func textFieldInit() {
        dictationTextField.text = ""
    }
    
    private func timerReset() {
        timer.invalidate()
        timerSettingView.isHidden = false
        countDownLabel.text = "00시00분00초"
        countDownLabel.textColor = .black
    }
    
    private func cardMoveAnimation(moveView: UIView, isMemorize: Bool) {
        let word = words[currentIndex]
        let animationPositionX = isMemorize ? moveView.center.x + moveView.bounds.width : moveView.center.x - moveView.bounds.width
        UIView.animate(withDuration: 0.3) {
            moveView.center = CGPoint(x: animationPositionX, y: moveView.center.y)
        } completion: { _ in
            word.isMemorize = isMemorize
            self.repository.update()
            self.quizResultWords.append(word)
            self.currentIndex += 1
            self.textFieldInit()
            self.cardViewSetup(index: self.currentIndex)
        }
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.bottomConstraint?.update(inset: keyboardHeight - 20)
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
        self.bottomConstraint?.update(inset: margin)
    }
    
    func bind() {
        viewModel.dateObservable.bind { [weak self] countDownDuration in
            guard let self else { return }
            if countDownDuration > 0 {
                self.setTimer(with: countDownDuration)
            }
        }
        viewModel.dismissHandler = { [weak self] in
            self?.dismiss(animated: true)
        }
    }
    
    private func setTimer(with countDownSeconds: Double) {
        let startTime = Date()
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
            let remainSeconds = Int(countDownSeconds) - elapsedTimeSeconds
            guard remainSeconds >= 0 else {
                timer.invalidate()
                self?.failedWordSetup()
                return
            }
            
            self?.countDownTime = remainSeconds
        })
    }
    
    private func failedWordSetup() {
        for index in currentIndex..<words.count {
            let word = words[index]
            word.isMemorize = false
            quizResultWords.append(word)
        }
        navigationPushQuizCompletePage()
    }
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch viewModel.quizType {
        case .meanDictation:
            frontCardView.koreaLabel.text = textField.text
        case .wordDictation:
            frontCardView.englishLabel.text = textField.text
        default:
            break
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardReturn()
        return true
    }
    
}
