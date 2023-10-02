//
//  FeatureCollectionViewCell.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import UIKit
import SnapKit

final class FeatureCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "FeatureCollectionViewCell"
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
private extension FeatureCollectionViewCell {
    
    func setUp(){
        self.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        imageView.backgroundColor = .black
    }
    
}
