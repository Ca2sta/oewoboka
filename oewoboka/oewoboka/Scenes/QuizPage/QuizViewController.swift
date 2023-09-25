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
    let vocablularyList: [Vocabulary] = []
    
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
        cardViewSetup()
        autoLayoutSetup()
    }
    
    func addViews() {
        view.addSubview(backgroundCardView)
        view.addSubview(frontCardView)
        view.addSubview(quizControlView)
    }
    
    func navigationSetup() {
        title = vocablularyList.first?.context
    }
    
    func cardViewSetup() {
//        guard let vocabulary = vocablularyList.first,
//              let word = vocabulary.words.first else { return }
//        cardView.englishLabel.text = word.english
//        cardView.koreaLabel.text = word.korea
        frontCardView.englishLabel.text = "영어"
        frontCardView.koreaLabel.text = "한글"
        frontCardView.layer.borderWidth = 1
        frontCardView.layer.borderColor = UIColor.black.cgColor
        frontCardView.layer.cornerRadius = 10
        frontCardView.layer.masksToBounds = true
        
        backgroundCardView.englishLabel.text = "영어2"
        backgroundCardView.koreaLabel.text = "한글2"
        backgroundCardView.layer.borderWidth = 1
        backgroundCardView.layer.borderColor = UIColor.black.cgColor
        backgroundCardView.layer.cornerRadius = 10
        backgroundCardView.layer.masksToBounds = true
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
}
