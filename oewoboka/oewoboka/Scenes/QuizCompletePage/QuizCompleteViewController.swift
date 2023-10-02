//
//  QuizCompleteViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class QuizCompleteViewController: UIViewController {
    
    private let middleView: UIView = UIView()
    private let resultView: CircleProgressBar
    private let quizFeedbackStackView: FeedBackStackView = FeedBackStackView()
    private let quizResultWords: [Word]
    var popCompletion: (([Word]?) -> Void)?
    
    init(words: [Word]) {
        quizResultWords = words
        let memorizeWords = quizResultWords.filter { $0.isMemorize }
        let rate = CGFloat(memorizeWords.count) / CGFloat(quizResultWords.count)
        resultView = CircleProgressBar(correctRate: rate, type: .percent, allWordCount: quizResultWords.count, isMemorizeCount: memorizeWords.count)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }

}

private extension QuizCompleteViewController {
    func setup() {
        addViews()
        autoLayoutSetup()
        resultViewSetup()
        quizFeedbackSetup()
        navigationSetup()
    }
    
    func addViews() {
        view.addSubview(middleView)
        middleView.addSubview(resultView)
        view.addSubview(quizFeedbackStackView)
    }
    
    func resultViewSetup() {
        resultView.progressBarSetupAnimation()
    }
    
    func quizFeedbackSetup() {
        quizFeedbackStackView.unMemorizeCount = quizResultWords.filter{ $0.isMemorize == false }.count
        quizFeedbackStackView.popHandler = { [weak self] resultType in
            switch resultType {
            case .answer:
                guard let self else { return }
                let vc = AnswerViewController(words: self.quizResultWords)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self.present(vc, animated: true)
            case .allReQuiz:
                self?.popCompletion?(self?.quizResultWords)
            case .unMemorizeReQuiz:
                let unMemorizeWords = self?.quizResultWords.filter { $0.isMemorize == false }
                self?.popCompletion?(unMemorizeWords)
            }
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        middleView.snp.makeConstraints { make in
            make.top.left.right.equalTo(safeArea)
            make.bottom.equalTo(quizFeedbackStackView.snp.top)
        }
        resultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(safeArea.snp.width).dividedBy(2)
        }
        quizFeedbackStackView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(safeArea).inset(24)
        }
    }
    
    func navigationSetup() {
        let backBarButton = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(backButtonClick))
        backBarButton.tintColor = .black
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = backBarButton
    }
    
    @objc func backButtonClick() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension QuizCompleteViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return BottomSheetPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
