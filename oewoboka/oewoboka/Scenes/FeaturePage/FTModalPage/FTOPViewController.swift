//
//  FTOPViewController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/26.
//

import UIKit
import SnapKit

final class FTOPViewController: UIViewController {
    
    lazy var topView = FTModalTopView(viewModel: viewModel)
    
    lazy var middleView = FTModalMiddleView(viewModel: viewModel)
    
    lazy var bottomView = FTModalBottomView(viewModel: viewModel)
    
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
    
}

extension FTOPViewController {
    // MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension FTOPViewController {
    // MARK: - SetUp
    
    func setUp() {
        view.backgroundColor = .systemBackground
        setUpTopView()
        setUpBottomView()
        setUpMiddleView()
        setUpAddTarget()
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
    
    // MARK: - SetUpAddTarget
    func setUpAddTarget() {
        topView.backButton.addTarget(self, action: #selector(didTappedBackButton), for: .touchUpInside)
        middleView.rangeView.rangeButton.addTarget(self, action: #selector(didTappedRangeButton), for: .touchUpInside)
        middleView.countView.plusButton.addTarget(self, action: #selector(didTappedCountButton(_:)), for: .touchUpInside)
        middleView.countView.minusButton.addTarget(self, action: #selector(didTappedCountButton(_:)), for: .touchUpInside)
        middleView.countView.sliderView.addTarget(self, action: #selector(didSlideSlider(_ :)), for: .valueChanged)
    }
    
    // MARK: - ButtonTappedMethod
    
    @objc func didTappedBackButton() {
        self.dismiss(animated: true)
    }
    
    @objc func didTappedRangeButton() {
        let yourVC = VocaListSelectedController(viewModel: self.viewModel)
        yourVC.modalPresentationStyle = .custom
        yourVC.transitioningDelegate = self
        self.present(yourVC, animated: true, completion: nil)
    }
    
    @objc func didTappedCountButton(_ button: UIButton) {
        if button == middleView.countView.plusButton {
            middleView.countView.count += 1
        } else {
            if middleView.countView.count > 0 {
                middleView.countView.count -= 1
            }
        }
    }
    
    @objc func didSlideSlider(_ slider: UISlider) {
        middleView.countView.count = Int(slider.value * 100)
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
//        guard let cell = collectionView.cellForItem(at: indexPath) as? FTSettingTypeCell else { return }
        print(indexPath.row)
    }
}

extension FTOPViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.6)
    }
}
