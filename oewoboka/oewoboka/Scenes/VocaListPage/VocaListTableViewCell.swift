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
        button.tintColor = .systemPink
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
        label.textColor = .systemPink
        return label
    }()
    let uncompleteNumbersLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemPink
        return label
    }()
    let inProgressRateLabel: CircleProgressBar = {
        let view = CircleProgressBar(correctRate: 0, type: .percent)
        view.resultViewLineWidth = 1
        view.progressBarLineWidth = 3
        view.correctRateLabel.font = Typography.body3.font
//        view.backgroundColor = .black
        view.lineColor = .systemRed
        return view
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
        
        // MARK: - total
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(systemName: "info.square")
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        attributedString1.append(NSAttributedString(string: "\(word.count)"))
        vocaNumbersLabel.attributedText = attributedString1
        // MARK: - cmp
        let attributedString2 = NSMutableAttributedString(string: "")
        let imageAttachment2 = NSTextAttachment()
        imageAttachment2.image = UIImage(systemName: "checkmark.square")?.withTintColor(.systemPink)
        attributedString2.append(NSAttributedString(attachment: imageAttachment2))
        attributedString2.append(NSAttributedString(string: "\(cmpCount)"))
        completeNumbersLabel.attributedText = attributedString2
        // MARK: - unCmp
        let attributedString3 = NSMutableAttributedString(string: "")
        let imageAttachment3 = NSTextAttachment()
        imageAttachment3.image = UIImage(systemName: "square")?.withTintColor(.systemPink)
        attributedString3.append(NSAttributedString(attachment: imageAttachment3))
        attributedString3.append(NSAttributedString(string: "\(unCmpCount)"))
        uncompleteNumbersLabel.attributedText = attributedString3
        
        let num1 = Double(word.count)
        let num2 = Double(cmpCount)
        var persent: Double = 0
        if num1 != 0 && num2 != 0 { persent = num2 / num1 }
        setUpProgressBar(persent: persent)

    }
    
    func setUpProgressBar(persent: Double) {

        inProgressRateLabel.progressBarSetupAnimation(rate: persent)
    }
    
    func setUpUI() {
        
        contentView.addSubview(vocaListLabel)
        contentView.addSubview(setButton)
        contentView.addSubview(inProgressRateLabel)
        contentView.addSubview(vocaNumbersLabel)
        contentView.addSubview(uncompleteNumbersLabel)
        contentView.addSubview(completeNumbersLabel)
  
        

        vocaListLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Constant.defalutPadding)
        }
        
        setButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(Constant.defalutPadding)
            make.width.equalTo(Constant.screenHeight * 0.05)
            make.height.equalTo(Constant.screenHeight * 0.05)
        }

        inProgressRateLabel.snp.makeConstraints { make in
            make.top.equalTo(setButton.snp.bottom).offset(Constant.defalutPadding)
            make.centerX.equalTo(setButton.snp.centerX)
            make.height.width.equalTo(Constant.screenHeight * 0.05)
            make.bottom.equalToSuperview().inset(Constant.defalutPadding)
        }
        vocaNumbersLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inProgressRateLabel.snp.bottom)
            make.left.equalToSuperview().inset(Constant.defalutPadding)
        }
        completeNumbersLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inProgressRateLabel.snp.bottom)
            make.left.equalTo(vocaNumbersLabel.snp.right).offset(Constant.defalutPadding)
        }
//
        uncompleteNumbersLabel.snp.makeConstraints { make in
            make.bottom.equalTo(inProgressRateLabel.snp.bottom)
            make.left.equalTo(completeNumbersLabel.snp.right).offset(Constant.defalutPadding)
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
