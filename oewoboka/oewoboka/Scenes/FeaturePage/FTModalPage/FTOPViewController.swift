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
    }
    
    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
        }
        topView.delegate = self
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
        middleView.rangeView.rangeDelegate = self
        middleView.countView.delegate = self
        middleView.typeView.typeCollectionView.register(FTSettingTypeCell.self, forCellWithReuseIdentifier: FTSettingTypeCell.identifier)
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
        print(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
}

extension FTOPViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.6)
    }
}

// MARK: - Custom Delegate extension

extension FTOPViewController: TopViewDelegate {
    func didTappedBackButton() {
        self.dismiss(animated: true)
    }
}

extension FTOPViewController: rangeButtonDelegate {
    func didTappedRangeButton() {
        let yourVC = VocaListSelectedController(viewModel: self.viewModel)
        yourVC.modalPresentationStyle = .custom
        yourVC.transitioningDelegate = self
        self.present(yourVC, animated: true, completion: nil)
    }
}

extension FTOPViewController: CountDelegate {
    func didTappedCountButton(_ button: UIButton) {
        if button == middleView.countView.plusButton {
            viewModel.count += 1
        } else {
            if viewModel.count > 0 {
                viewModel.count -= 1
                print(viewModel.count)
            }
        }
        middleView.countView.viewUpdate()
    }
    
    func didSlideSlider(_ slider: UISlider) {
        viewModel.count = Int(slider.value * 100)
        middleView.countView.viewUpdate()
        print(viewModel.count)
    }
}
