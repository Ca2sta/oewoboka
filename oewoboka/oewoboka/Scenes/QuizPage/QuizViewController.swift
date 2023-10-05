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
        textField.placeholder = quizType == .meanDictation ? "의미를 작성한 뒤 엔터를 눌러주세요" : "단어를 작성한 뒤 엔터를 눌러주세요"
        textField.font = Typography.title3.font
        textField.textColor = .black
        textField.borderStyle = .roundedRect
        return textField
    }()
    private let margin: CGFloat = 24
    private var currentIndex: Int = 0
    private var bottomConstraint: Constraint?
    
    let vocabularyList: [VocabularyEntity]
    private let quizType: QuizType
    private let featureType: Feature
    private var quizResultWords: [WordEntity] = []
    private var words: [WordEntity] = []
    private let repository = VocabularyRepository.shared
    
    init(quizData: QuizSettingData) {
        if quizData.featureType == .wordCard {
            self.quizType = .training
        } else if quizData.featureType == .dictation {
            self.quizType = quizData.quizType
        } else {
            self.quizType = .test
        }
        self.featureType = quizData.featureType
        self.vocabularyList = quizData.selectedVocabulary.isEmpty ? repository.allFetch() : quizData.selectedVocabulary
        super.init(nibName: nil, bundle: nil)
        quizTypeSetup()
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
    }
    
    func addViews() {
        view.addSubview(backgroundCardView)
        view.addSubview(frontCardView)
        if quizType == .training {
            view.addSubview(quizControlView)
        } else {
            view.addSubview(dictationStackView)
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
        
        //MARK: 더미이므로 지워야함
        let word = Word(english: "영어", korea: "한글", isMemorize: false, isBookmark: false)
        vocabularyList.map{ repository.addWord(vocabularyEntityId: $0.objectID, word: word) }
        
        
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
        
        if featureType == .dictation {
            if quizType == .meanDictation {
                frontCardView.koreaLabel.text = ""
            } else if quizType == .wordDictation {
                frontCardView.englishLabel.text = ""
            }
        } else if featureType == .wordCard {
            
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
        
        if quizType == .meanDictation {
            backgroundCardView.koreaLabel.text = ""
        } else if quizType == .wordDictation {
            backgroundCardView.englishLabel.text = ""
        }
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        var bottomViewHeight = 0.0
        var cardViewBottomConstraint: Constraint? = nil
        
        frontCardView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea).inset(margin)
            cardViewBottomConstraint = make.bottom.equalTo(safeArea).constraint
        }
        backgroundCardView.snp.makeConstraints { make in
            make.edges.equalTo(frontCardView)
        }
        
        if quizType == .training {
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
        frontCardView.quizType = quizType
        backgroundCardView.quizType = quizType
    }
    
    func textFieldSetup() {
        dictationTextField.delegate = self
        dictationTextField.becomeFirstResponder()
    }
    
    func keyboardReturn() {
        switch quizType {
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
        let vc = QuizCompleteViewController(words: quizResultWords)
        vc.popCompletion = { [weak self] words in
            guard let self else { return }
            if let words {
                self.words = words
            }
            self.backgroundCardView.isHidden = false
            self.quizResultWords = []
            self.currentIndex = 0
            self.cardViewSetup(index: currentIndex)
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
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        switch quizType {
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
