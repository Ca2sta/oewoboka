//
//  VocaListTableViewCell.swift
//  oewoboka
//
//  Created by Lee on 2023/09/26.
//
import UIKit
import SnapKit

class VocaListTableViewCell: UITableViewCell {
    static let identifier = "ListCell"
    
    let setButton: UIButton = {
        let button = UIButton(type: .system)
        return button
    }()
    let vocaListLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let vocaNumbersLabel: UILabel = {
         let label = UILabel()
         return label
     }()
    let completeNumbersLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let uncompleteNumbersLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    let achievementRate: UILabel = {
        let label = UILabel()
        label.backgroundColor = .purple
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
        setButton.setImage(UIImage(systemName: "text.justify"), for: .normal)


    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setUpUI() {
        contentView.addSubview(setButton)
        addSubview(setButton)
        addSubview(vocaListLabel)
        addSubview(vocaNumbersLabel)
        addSubview(uncompleteNumbersLabel)
        addSubview(completeNumbersLabel)
        addSubview(achievementRate)
        
        
        setButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(30)
            make.height.equalTo(30)
        }
        achievementRate.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(45)
            make.height.equalTo(55)
        }
        vocaNumbersLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }
        completeNumbersLabel.snp.makeConstraints { make in
            make.left.equalTo(vocaNumbersLabel.snp.right).offset(25)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }

        uncompleteNumbersLabel.snp.makeConstraints { make in
            make.left.equalTo(completeNumbersLabel.snp.right).offset(25)
            make.bottom.equalToSuperview().offset(-8)
            make.width.equalTo(70)
            make.height.equalTo(20)
        }

        vocaListLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(setButton.snp.left).offset(-10)
            make.bottom.equalTo(vocaNumbersLabel.snp.top).offset(-10)
        }

        
    }
    override func layoutSubviews() {
      super.layoutSubviews()
    }
    
    @objc func setButtonTapped() {
        print("test")
    }

}
