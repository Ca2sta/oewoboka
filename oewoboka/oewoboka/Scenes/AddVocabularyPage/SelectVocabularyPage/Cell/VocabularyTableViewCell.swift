//
//  VocabularyTableViewCell.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/04.
//

import UIKit
import SnapKit

final class VocabularyTableViewCell: UITableViewCell {
    static let identifier: String = "\(VocabularyTableViewCell.self)"
    private let leftImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "doc.on.doc"))
        imageView.tintColor = .black
        return imageView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        label.text = "test"
        label.textColor = .black
        return label
    }()
    private let margin: CGFloat = 12
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        DispatchQueue.main.async {
            self.leftImageView.tintColor = selected ? .systemRed : .black
            self.titleLabel.textColor = selected ? .systemRed : .black
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension VocabularyTableViewCell {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    
    func addViews() {
        contentView.addSubview(leftImageView)
        contentView.addSubview(titleLabel)
    }
    
    func autoLayoutSetup() {
        leftImageView.snp.makeConstraints { make in
            make.left.equalTo(contentView.snp.left).inset(margin)
            make.top.bottom.equalTo(contentView).inset(margin)
        }
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(leftImageView.snp.right).offset(margin)
            make.top.bottom.equalTo(contentView).inset(margin)
        }
    }
}

