//
//  QuizViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import Foundation
import UIKit

final class QuizViewController: UIViewController {
    
    private let frontCardView: CardView = CardView()
    private let backgroundCardView: CardView = CardView()
    private let quizControlView: QuizControlStackView = QuizControlStackView(buttonSize: CGSize(width: 52.0, height: 52.0))
    private let margin: CGFloat = 24
    private var currentIndex: Int = 0
    
    let vocabularyList: [VocabularyEntity]
    private let quizType: QuizType
    private var quizResultWords: [WordEntity] = []
    private var words: [WordEntity] = []
    
    init(quizData: QuizSettingData) {
        self.quizType = quizData.quizType
        self.vocabularyList = quizData.selectedVocabulary
        super.init(nibName: nil, bundle: nil)
        quizTypeSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
}

private extension QuizViewController {
    func setup() {
        addViews()
        navigationSetup()
        initCardView()
        cardViewSetup(index: currentIndex)
        autoLayoutSetup()
    }
    
    func addViews() {
        view.addSubview(backgroundCardView)
        view.addSubview(frontCardView)
        view.addSubview(quizControlView)
    }
    
    func navigationSetup() {
        title = "단어보기"
    }
    
    func initCardView() {
        guard let vocabularyWords = vocabularyList.first?.words?.array as? [WordEntity] else { return }
        words = vocabularyWords
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cardMove(sender:)))
        frontCardView.isUserInteractionEnabled = true
        frontCardView.addGestureRecognizer(panGesture)
        
        frontCardView.layer.borderWidth = 1
        frontCardView.layer.borderColor = UIColor.black.cgColor
        frontCardView.layer.cornerRadius = 10
        frontCardView.layer.masksToBounds = true
        
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor.black.cgColor
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.masksToBounds = true
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
        
        let nextIndex = index + 1
        guard nextIndex  < words.count else {
            backgroundCardView.isHidden = true
            return
        }
        
        let nextWord = words[nextIndex]
        let nextCountText = "\(nextIndex + 1) / \(words.count)"
        backgroundCardView.wordCountLabel.text = nextCountText
        backgroundCardView.englishLabel.text = nextWord.english
        backgroundCardView.koreaLabel.text = nextWord.korea
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        frontCardView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea).inset(margin)
        }
        backgroundCardView.snp.makeConstraints { make in
            make.edges.equalTo(frontCardView)
        }
        quizControlView.snp.makeConstraints { make in
            make.top.equalTo(frontCardView.snp.bottom).offset(margin)
            make.height.equalTo(52)
            make.left.right.bottom.equalTo(safeArea).inset(margin)
        }
    }
    
    func quizTypeSetup() {
        frontCardView.quizType = quizType
        backgroundCardView.quizType = quizType
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
                
        var word = vocabularyList.first!.words![currentIndex] as! WordEntity
        
        if sender.state == .ended {
            if moveView.center.x < 75 {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = CGPoint(x: moveView.center.x - moveView.bounds.width, y: moveView.center.y)
                } completion: { _ in
                    word.isMemorize = false
                    self.quizResultWords.append(word)
                    self.currentIndex += 1
                    self.cardViewSetup(index: self.currentIndex)
                }
            } else if moveView.center.x > (view.bounds.width - 75) {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = CGPoint(x: moveView.center.x + moveView.bounds.width, y: moveView.center.y)
                } completion: { _ in
                    word.isMemorize = true
                    self.quizResultWords.append(word)
                    self.currentIndex += 1
                    self.cardViewSetup(index: self.currentIndex)
                }
            } else {
                UIView.animate(withDuration: 0.3) {
                    moveView.center = self.backgroundCardView.center
                }
            }
        }
    }
}
