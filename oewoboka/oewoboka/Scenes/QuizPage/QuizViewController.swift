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

    private var timer = Timer()
    private let quizMainView: QuizMainView
    private let viewModel: QuizViewModel
    
    private let margin: CGFloat = 24
    
    init(quizData: QuizSettingData) {
        self.viewModel = QuizViewModel(quizData: quizData)
        self.quizMainView = QuizMainView(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
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
        setupAutoLayout()
        setupNavigation()
        setupCardView()
        addCardViewGesture()
        textFieldSetup()
        bind()
    }
    
    func addViews() {
        view.addSubview(quizMainView)
    }
    
    func setupAutoLayout() {
        quizMainView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setupNavigation() {
        let leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .done, target: self, action: #selector(popViewController))
        leftBarButtonItem.tintColor = .black
        navigationItem.leftBarButtonItem = leftBarButtonItem
        navigationItem.title = "단어보기"
    }
    
    @objc private func popViewController() {
        dismiss(animated: true)
    }
    
    func addCardViewGesture() {
        
        if viewModel.isWordCard {
            let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cardMove(sender:)))
            quizMainView.frontCardView.addGestureRecognizer(panGesture)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(keyboardDismiss(sender:)))
        quizMainView.frontCardView.isUserInteractionEnabled = true
        quizMainView.frontCardView.addGestureRecognizer(tapGesture)
    }
    
    @objc func keyboardDismiss(sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    func textFieldSetup() {
        quizMainView.dictationTextField.delegate = self
        quizMainView.dictationTextField.becomeFirstResponder()
    }
    
    func keyboardReturn() {
        if viewModel.isMatch {
            cardMoveAnimation(moveView: quizMainView.frontCardView, isMemorize: true)
        }
    }
    
    func setupCardView() {
        if viewModel.isComplete {
            navigationPushQuizCompletePage()
            return
        }
        quizMainView.setupCardView()
    }
    
    func navigationPushQuizCompletePage() {
        let vc = QuizCompleteViewController(viewModel: viewModel)
        vc.popCompletion = { [weak self] in
            guard let self else { return }
            self.viewModel.reQuizWordSetting()
            self.quizMainView.backgroundCardView.isHidden = false
            self.setupCardView()
            if self.viewModel.isTestType {
                timer.invalidate()
                quizMainView.timerReset()
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
                    moveView.center = self.quizMainView.backgroundCardView.center
                }
            }
        }
    }
    
    private func cardMoveAnimation(moveView: UIView, isMemorize: Bool) {
        let word = viewModel.currentWord
        let animationPositionX = isMemorize ? moveView.center.x + moveView.bounds.width : moveView.center.x - moveView.bounds.width
        UIView.animate(withDuration: 0.3) {
            moveView.center = CGPoint(x: animationPositionX, y: moveView.center.y)
        } completion: { _ in
            word.isMemorize = isMemorize
            self.viewModel.repository.update()
            self.viewModel.quizResultWords.append(word)
            self.viewModel.next()
            self.quizMainView.textFieldInit()
            self.setupCardView()
        }
    }
    
    @objc func keyBoardWillShow(notification: NSNotification) {
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        self.quizMainView.bottomConstraint?.update(inset: keyboardHeight - 20)
    }

    @objc func keyBoardWillHide(notification: NSNotification) {
        self.quizMainView.bottomConstraint?.update(inset: margin)
    }
    
    func bind() {
        viewModel.dateObservable.bind { [weak self] countDownDuration in
            guard let self else { return }
            if countDownDuration > 0 {
                self.setTimer(with: countDownDuration)
            }
        }
        viewModel.bookMarkUpdateObservable.bind { [weak self] isBookmark in
            guard let self else { return }
            viewModel.currentWord.isBookmark = isBookmark
        }
        viewModel.hiddenQuizObservable.bind { [weak self] isHidden in
            guard let self else { return }
            if self.viewModel.isMeanDictation { self.quizMainView.frontCardView.koreaLabel.alpha = isHidden ? 0.0 : 1 }
            else if self.viewModel.isWordDictation { self.quizMainView.frontCardView.englishLabel.alpha = isHidden ? 0.0 : 1 }
        }
        viewModel.nextHandler = { [weak self] isMemorize in
            guard let self else { return }
            self.cardMoveAnimation(moveView: quizMainView.frontCardView, isMemorize: isMemorize)
        }
        viewModel.reQuizHandler = { [weak self] in
            guard let self else { return }
            self.quizMainView.backgroundCardView.isHidden = false
            self.viewModel.reQuizWordSetting()
            self.setupCardView()
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
            
            self?.quizMainView.countDownTime = remainSeconds
        })
    }
    
    private func failedWordSetup() {
        viewModel.restWordsFailure()
        navigationPushQuizCompletePage()
    }
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        viewModel.dictationText = textField.text
        quizMainView.frontCardView.koreaLabel.text = viewModel.currentKoreaLabelText
        quizMainView.frontCardView.englishLabel.text = viewModel.currentEnglishLabelText
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        keyboardReturn()
        return true
    }
}
