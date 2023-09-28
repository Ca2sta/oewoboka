//
//  FTOPViewController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/26.
//

import UIKit
import SnapKit

final class FTOPViewController: UIViewController {
    
    private let topView = FTModalTopView()
    
    private let bottomView = FTModalBottomView()
    
    var type: FeatureChoice
    
    init(data: FeatureCellModel) {
        self.type = data.type
        super.init(nibName: nil, bundle: nil)
        topView.titleLabel.text = data.title
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    deinit {
//        print("FTOPViewController deinit")
//    }
}

extension FTOPViewController {
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        topView.backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
    }
}

private extension FTOPViewController {
    // MARK: - SetUp
    
    func setUp() {
        view.backgroundColor = .systemBackground
        setUpTopView()
        setUpBottomView()
        setUpScrollView()
    }
    
    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
    }
    
    func setUpBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
    }
    
}

private extension FTOPViewController {
    // MARK: - ButtonTappedMethod
    
    @objc func didTappedBackButton() {
        self.dismiss(animated: true)
    }
}

