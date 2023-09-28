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
    
    private let middleView = FTModalMiddleView()
    
    private let bottomView = FTModalBottomView()
    
    private let viewModel = FTOPViewModel()
    
    var type: FeatureChoice
    
    init(data: FeatureCellModel) {
        self.type = data.type
        super.init(nibName: nil, bundle: nil)
        topView.titleLabel.text = "\(data.title) 설정"
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
        setUpMiddleView()
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
    
    func setUpMiddleView() {
        view.addSubview(middleView)
        middleView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalTo(bottomView.snp.top)
            make.left.right.equalToSuperview()
        }
        middleView.typeView.typeCollectionView.delegate = self
        middleView.typeView.typeCollectionView.dataSource = self
        middleView.typeView.typeCollectionView.register(FTSettingTypeCell.self, forCellWithReuseIdentifier: FTSettingTypeCell.identifier)
    }
    
}

private extension FTOPViewController {
    // MARK: - ButtonTappedMethod
    
    @objc func didTappedBackButton() {
        self.dismiss(animated: true)
    }
}

extension FTOPViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.quizType.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.middleView.typeView.typeCollectionView.dequeueReusableCell(
            withReuseIdentifier: FTSettingTypeCell.identifier,
            for: indexPath
        ) as! FTSettingTypeCell
        cell.bind(title: viewModel.quizType[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? FTSettingTypeCell else { return }
        print(indexPath.row)
    }
    
    
}

