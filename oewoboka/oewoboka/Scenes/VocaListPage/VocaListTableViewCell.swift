//

//  vocaListTableViewCell.swift
//  oewoboka
//
//  Created by Lee on 2023/09/25.
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
        label.font = Typography.title1.font
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

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)

        setButton.setImage(UIImage(systemName: "text.justify"), for: .normal)


    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(data: VocabularyEntity) {
        let word = data.words?.array as! [WordEntity]
        let cmpCount = word.filter{$0.isMemorize == true}.count
        let unCmpCount = word.count - cmpCount
        vocaListLabel.text = data.title
        vocaNumbersLabel.text = "V: \(word.count)"
        completeNumbersLabel.text = "✅: \(cmpCount)"
        uncompleteNumbersLabel.text = "❎: \(unCmpCount)"
        
        let num1 = Double(word.count)
        let num2 = Double(cmpCount)
        var persent: Double = 0
        if num1 != 0 && num2 != 0 { persent = num2 / num1 }
        setUpProgressBar(persent: persent)
    }
    
    func setUpProgressBar(persent: Double) {
        
        let inProgressRateLabel: CircleProgressBar = {
            let view = CircleProgressBar(correctRate: persent, type: .percent)
            view.resultViewLineWidth = 0.5
            view.progressBarLineWidth = 1
            view.correctRateLabel.font = Typography.body3.font
            view.lineColor = .systemRed
            return view
        }()
        contentView.addSubview(inProgressRateLabel)
        inProgressRateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-8)
            make.width.height.equalTo(Constant.screenWidth * 0.1)
        }
        inProgressRateLabel.progressBarSetupAnimation()
    }
    
    func setUpUI() {
        
        contentView.addSubview(setButton)
        contentView.addSubview(vocaListLabel)
        contentView.addSubview(vocaNumbersLabel)
        contentView.addSubview(uncompleteNumbersLabel)
        contentView.addSubview(completeNumbersLabel)

        
        setButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.width.equalTo(30)
            make.height.equalTo(30)
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
            make.bottom.equalTo(vocaNumbersLabel.snp.top).offset(-10)
        }

        
    }
    
    @objc func setButtonTapped() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let editAction = UIAlertAction(title: "수정", style: .default) { _ in
            print("수정을 선택했습니다.")
        }

        let copyAction = UIAlertAction(title: "복사", style: .default) { _ in
            print("복사를 선택했습니다.")
        }

        let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in

            print("삭제를 선택했습니다.")
        }

        let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)

        alertController.addAction(editAction)
        alertController.addAction(copyAction)
        alertController.addAction(deleteAction)
        alertController.addAction(cancelAction)

        if let viewController = UIApplication.shared.keyWindow?.rootViewController {
            viewController.present(alertController, animated: true, completion: nil)
        }
    }

}
