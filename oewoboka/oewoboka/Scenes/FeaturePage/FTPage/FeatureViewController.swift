//
//  FeatureViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import Foundation
import UIKit
import SnapKit

final class FeatureViewController: UIViewController {
    
    private let viewModel = FeatureViewModel()
    
    private let divider: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray
        return view
    }()
    
    lazy var featureCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        let cellWidth: CGFloat = floor(viewModel.cellSize.width)
        let insetX = (Constant.screenWidth - cellWidth) / 2.0
        collectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.decelerationRate = .fast
        return collectionView
    }()
}

extension FeatureViewController {
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.titleTextAttributes = viewModel.titleLabelFont
        navigationItem.title = viewModel.titleLabelText
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
}

private extension FeatureViewController {
    // MARK: - SetUp

    func setUp() {
        setUpDividerView()
        setUpFeatureCollectionView()
    }
    
    func setUpDividerView() {
        view.addSubview(divider)
        divider.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setUpFeatureCollectionView() {
        view.addSubview(featureCollectionView)
        featureCollectionView.register(
            FeatureCollectionViewCell.self,
            forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier
        )
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.snp.makeConstraints { make in
            make.centerY.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(Constant.screenHeight * 0.6)
        }
    }
    
}

private extension FeatureViewController {
    // MARK: - Animation
    func animateZoomforCell(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { zoomCell.transform = CGAffineTransform( scaleX: 1.2, y: 1.2) },
            completion: nil)
    }
    
    func animateZoomforCellremove(zoomCell: UICollectionViewCell) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0,
            options: .curveEaseOut,
            animations: { zoomCell.transform = .identity },
            completion: nil)
        
    }
}

extension FeatureViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.features.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.featureCollectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as? FeatureCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bind(data: viewModel.features[indexPath.row])
        return cell
    }
}

extension FeatureViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    // MARK: - CollectionView Method

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let yourVC = FTOPViewController(data: viewModel.features[indexPath.row])
        yourVC.modalPresentationStyle = .custom
        yourVC.transitioningDelegate = self
        self.present(yourVC, animated: true, completion: nil)
    }
    
    // MARK: - ScrollView Method
    // MARK: Paging Effect
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let cellWidthIncludeSpacing = viewModel.cellSize.width + viewModel.minItemSpacing

        var offset = targetContentOffset.pointee
        let index = (offset.x + scrollView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex: CGFloat = round(index)
        offset = CGPoint(x: roundedIndex * cellWidthIncludeSpacing - scrollView.contentInset.left, y: scrollView.contentInset.top)
        targetContentOffset.pointee = offset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let cellWidthIncludeSpacing = viewModel.cellSize.width + viewModel.minItemSpacing
        let offsetX = featureCollectionView.contentOffset.x
        let index = (offsetX + featureCollectionView.contentInset.left) / cellWidthIncludeSpacing
        let roundedIndex = round(index)
        let indexPath = IndexPath(item: Int(roundedIndex), section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let self = self else {return}
            guard let cell = featureCollectionView.cellForItem(at: indexPath) as? FeatureCollectionViewCell else { return }
            cell.colorLoad(color: UIColor.systemPink)
            animateZoomforCell(zoomCell: cell)
        }
        if Int(roundedIndex) != viewModel.previousIndex {
            let preIndexPath = IndexPath(item: viewModel.previousIndex, section: 0)
            if let preCell = featureCollectionView.cellForItem(at: preIndexPath) as? FeatureCollectionViewCell {
                preCell.colorLoad(color: UIColor.systemGray)
                animateZoomforCellremove(zoomCell: preCell)
            }
            viewModel.previousIndex = indexPath.item
        }
    }
}
extension FeatureViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        PresentationController(presentedViewController: presented, presenting: presenting, size: 0.8)
        
        
    }
}
