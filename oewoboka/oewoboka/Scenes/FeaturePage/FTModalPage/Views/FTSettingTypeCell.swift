//
//  FTSettingTypeCell.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/28.
//

import UIKit
import SnapKit

final class FTSettingTypeCell: UICollectionViewCell {
    
    private let title: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        return label
    }()
    
    lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: "circle")
        view.tintColor = .systemGray
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                imageView.image = UIImage(systemName: "record.circle")
                imageView.tintColor = .systemPink
                title.textColor = .systemPink
            } else {
                imageView.image = UIImage(systemName: "circle")
                imageView.tintColor = .systemGray
                title.textColor = .black
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension FTSettingTypeCell {
    func setUp(){
        contentView.addSubview(title)
        title.snp.makeConstraints { make in
            make.centerY.left.equalToSuperview()
        }
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerY.right.equalToSuperview()
            make.height.width.equalTo(title.snp.height)
        }
    }
}

extension FTSettingTypeCell {
    func bind(title: String) {
        self.title.text = title
    }
}

extension FTSettingTypeCell: CollectionViewIdentifier {
    static var identifier: String {
        String(describing: type(of: self))
    }
}
