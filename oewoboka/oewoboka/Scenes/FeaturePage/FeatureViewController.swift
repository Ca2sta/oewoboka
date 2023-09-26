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
    
//    private let titleLabel = UILabel()
    
    private let divider = UIView()
    
    private let featureCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        flowLayout.scrollDirection = .horizontal
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
}

private extension FeatureViewController {
    // MARK: - SetUp

    func setUp() {
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: Typography.title2Medium.font]
        navigationItem.title = "퀴즈"
        setUpDividerView()
        setUpFeatureCollectionView()
    }
    
//    func setUpTitleLabel() {
//        view.addSubview(titleLabel)
//        titleLabel.text = "퀴즈"
//        titleLabel.font = Typography.title2Medium.font
//        titleLabel.textAlignment = .center
//        titleLabel.snp.makeConstraints { make in
//            make.top.equalTo(view.safeAreaLayoutGuide)
//            make.left.right.equalToSuperview()
//        }
//    }
    
    func setUpDividerView() {
        view.addSubview(divider)
        divider.backgroundColor = .systemGray
        divider.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
    }
    
    func setUpFeatureCollectionView() {
        view.addSubview(featureCollectionView)
        let cellWidth: CGFloat = floor(viewModel.cellSize.width)
        let insetX = (view.bounds.width - cellWidth) / 2.0
        
        featureCollectionView.contentInset = UIEdgeInsets(top: 0, left: insetX, bottom: 0, right: insetX)
        featureCollectionView.showsHorizontalScrollIndicator = false
        featureCollectionView.decelerationRate = .fast
        featureCollectionView.register(
            FeatureCollectionViewCell.self,
            forCellWithReuseIdentifier: FeatureCollectionViewCell.identifier
        )
        featureCollectionView.delegate = self
        featureCollectionView.dataSource = self
        featureCollectionView.snp.makeConstraints { make in
            make.top.equalTo(divider.snp.bottom).offset(Constant.defalutPadding)
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
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
        viewModel.testAry.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = self.featureCollectionView.dequeueReusableCell(withReuseIdentifier: FeatureCollectionViewCell.identifier, for: indexPath) as? FeatureCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.bind(data: viewModel.testAry[indexPath.row])
        return cell
    }
}

extension FeatureViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.minItemSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return viewModel.cellSize
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
    }
    
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
            guard let cell = featureCollectionView.cellForItem(at: indexPath) else { return }
            cell.contentView.layer.borderColor = UIColor.systemPink.cgColor
            animateZoomforCell(zoomCell: cell)
        }
        if Int(roundedIndex) != viewModel.previousIndex {
            let preIndexPath = IndexPath(item: viewModel.previousIndex, section: 0)
            if let preCell = featureCollectionView.cellForItem(at: preIndexPath) {
                preCell.contentView.layer.borderColor = UIColor.systemGray.cgColor
                animateZoomforCellremove(zoomCell: preCell)
            }
            viewModel.previousIndex = indexPath.item
        }
    }
}
