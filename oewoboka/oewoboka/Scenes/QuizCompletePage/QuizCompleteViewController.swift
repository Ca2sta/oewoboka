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
    private lazy var quizFeedbackStackView: FeedBackStackView = FeedBackStackView(viewModel: viewModel)
    private let viewModel: QuizViewModel
    var popCompletion: (() -> Void)?
    
    init(viewModel: QuizViewModel) {
        self.viewModel = viewModel
        resultView = CircleProgressBar(correctRate: 0, type: .number, allWordCount:  viewModel.quizResultWords.count, isMemorizeCount: viewModel.memorizeWords.count)
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
        resultView.progressBarSetupAnimation(rate: viewModel.progressRate)
    }
    
    func quizFeedbackSetup() {
        quizFeedbackStackView.popHandler = { [weak self] resultType in
            switch resultType {
            case .answer:
                guard let self else { return }
                let vc = AnswerViewController(words: self.viewModel.quizResultWords)
                vc.modalPresentationStyle = .custom
                vc.transitioningDelegate = self
                self.present(vc, animated: true)
            case .allReQuiz:
                self?.popCompletion?()
            case .unMemorizeReQuiz:
                self?.viewModel.unMemorizeReQuiz()
                self?.popCompletion?()
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
        navigationItem.title = "결과화면"
    }
    
    @objc func backButtonClick() {
        dismiss(animated: true)
    }
}

extension QuizCompleteViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
    }
}
