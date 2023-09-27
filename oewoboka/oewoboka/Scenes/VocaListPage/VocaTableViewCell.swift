//
//  VocaTableViewCell.swift
//  oewoboka
//
import UIKit
import SnapKit

class VocaTableViewCell: UITableViewCell {
    static let identifier = "VocaCell"
    
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        return label
    }()
    let isCompleteButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    let vocaLabel : UILabel = {
        let label = UILabel()
        label.text = "development"
        label.font = Typography.title1.font
        return label
    }()
    let partLabel : UILabel = {
        let label = UILabel()
        label.text = "명사"
        label.font = Typography.body1.font
        return label
    }()
    let koreanLabel : UILabel = {
        let label = UILabel()
        label.text = "발달,성장,개발"
        label.font = Typography.body1.font
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        
        isCompleteButton.addTarget(self, action: #selector(isCompleteButtonTapped), for: .touchUpInside)
        isCompleteButton.setImage(UIImage(systemName: "text.justify"), for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpUI() {
        addSubview(dateLabel)
        contentView.addSubview(isCompleteButton)
        addSubview(vocaLabel)
        addSubview(partLabel)
        addSubview(koreanLabel)
        
        
        dateLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(10)
            make.right.equalTo(isCompleteButton.snp.left)
            make.height.equalTo(15)
        }
        isCompleteButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().inset(10)
        }
        vocaLabel.snp.makeConstraints { make in
            make.bottom.equalTo(partLabel.snp.top).offset(-10)
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        partLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
            make.width.equalTo(45)
            make.height.equalTo(30)
        }
        koreanLabel.snp.makeConstraints { make in
            make.left.equalTo(partLabel.snp.right).offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(vocaLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }
    @objc func isCompleteButtonTapped() {
        print("test")
    }
}
