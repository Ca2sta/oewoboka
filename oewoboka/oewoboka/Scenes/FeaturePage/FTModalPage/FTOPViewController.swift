//
//  FTOPViewController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/26.
//

import UIKit
import SnapKit

final class FTOPViewController: BottomSheetViewController {
    
    lazy var topView = PageTopView(title: "")
    
    lazy var middleView = FTModalMiddleView(viewModel: viewModel)
    
    lazy var bottomView = FTModalBottomView(viewModel: viewModel)
    
    private let viewModel = FTOPViewModel()
    
    var type: Feature
    
    init(data: FeatureCellModel) {
        self.type = data.type
        super.init()
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
        topView.buttonDelegate = self
    }
    
    func setUpBottomView() {
        view.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
        }
        bottomView.buttonDelegate = self
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
        middleView.rangeView.buttonDelegate = self
        middleView.countView.buttonDelegate = self
        middleView.countView.sliderDelegate = self
        middleView.typeView.typeCollectionView.register(FTSettingTypeCell.self, forCellWithReuseIdentifier: FTSettingTypeCell.identifier)
    }
    
}

extension FTOPViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.middleView.typeView.typeCollectionView.dequeueReusableCell(
            withReuseIdentifier: FTSettingTypeCell.identifier,
            for: indexPath
        ) as! FTSettingTypeCell
        cell.bind(title: viewModel.features[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            viewModel.quizType = .wordDictation
        case 1:
            viewModel.quizType = .meanDictation
        default:
            print("index Error")
        }
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

extension FTOPViewController: ViewHasButton {
    func didTappedButton(button: UIButton) {
        switch button {
        case topView.backButton:
            self.dismiss(animated: true)
        case middleView.rangeView.rangeButton:
            let yourVC = VocaListSelectedController(viewModel: self.viewModel)
            yourVC.modalPresentationStyle = .custom
            yourVC.transitioningDelegate = self
            self.present(yourVC, animated: true, completion: nil)
        case middleView.countView.plusButton:
            viewModel.count.value += 1
        case middleView.countView.minusButton:
            if viewModel.count.value > 0 { viewModel.count.value -= 1 }
        case bottomView.startButton:
            if viewModel.vocaList.value.compactMap({ $0.words?.array as? [WordEntity] }).flatMap({ $0 }).count == 0 {
                let alert  = UIAlertController(title: "경고", message: "단어장에 단어가 존재하지 않습니다.", preferredStyle: .alert)
                let yes = UIAlertAction(title: "확인", style: .destructive)
                alert.addAction(yes)
                self.present(alert, animated: true)
            } else {
                let data = QuizSettingData(featureType: self.type, selectedVocabulary: viewModel.vocaList.value, quizType: viewModel.quizType, quizCount: viewModel.count.value)
                let vc = UINavigationController(rootViewController: QuizViewController(quizData: data))
                vc.modalPresentationStyle = .fullScreen
                guard let pvc = self.presentingViewController else { return }
                self.dismiss(animated: true) {
                  pvc.present(vc, animated: true, completion: nil)
                }
            }
        default:
            print("Button not registered")
        }
    }
}

extension FTOPViewController: ViewHasSlider {
    
    func didSlideSlider(_ slider: UISlider) {
        viewModel.count.value = Int(slider.value * 100)
    }
}
