//
//  QuizCompleteViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class QuizCompleteViewController: UIViewController {
    
    let resultView: ResultView = ResultView()

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
    }
    
    func addViews() {
        view.addSubview(resultView)
    }
    
    func resultViewSetup() {
        resultView.progressBarSetupAnimation()
    }
    
    func autoLayoutSetup() {
        let safeArea = view.safeAreaLayoutGuide
        resultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(safeArea.snp.width).dividedBy(2)
        }
    }
}
