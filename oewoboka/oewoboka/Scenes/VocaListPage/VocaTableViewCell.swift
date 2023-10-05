//
//  VocaTableViewCell.swift
//  oewoboka
//
import UIKit
import SnapKit
import CoreData

class VocaTableViewCell: UITableViewCell {
    
    static let identifier = "VocaCell"
    
    var buttonState = 2
    
    var data: WordEntity?
    
    let mananger = VocabularyRepository.shared
    
    var vocabularyID: NSManagedObjectID?
    
    let imageConfig = UIImage.SymbolConfiguration(pointSize: Constant.screenHeight * 0.05, weight: .light)
    
    let isCompleteButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 300, weight: .light)
        let image = UIImage(systemName: "square", withConfiguration: imageConfig)
        button.tintColor = .systemPink
        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill

        return button
    }()
    let vocaLabel : UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        return label
    }()
    let koreanLabel : UILabel = {
        let label = UILabel()
        label.font = Typography.body1.font
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
        
        isCompleteButton.addTarget(self, action: #selector(isCompleteButtonTapped), for: .touchUpInside)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(vocabularyID: NSManagedObjectID, index: Int) {
        
        guard let data = mananger.fetch(id: vocabularyID)?.words?.array as? [WordEntity] else { return }
        self.data = data[index]
        
        
        let attributedString1 = NSMutableAttributedString(string: "")
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage(systemName: "e.square")?.withTintColor(.systemPink)
        attributedString1.append(NSAttributedString(attachment: imageAttachment1))
        attributedString1.append(NSAttributedString(string: " " + data[index].english!))
        vocaLabel.attributedText = attributedString1
        
        let attributedString2 = NSMutableAttributedString(string: "")
        let imageAttachment2 = NSTextAttachment()
        imageAttachment2.image = UIImage(systemName: "k.square")?.withTintColor(.systemPink)
        attributedString2.append(NSAttributedString(attachment: imageAttachment2))
        attributedString2.append(NSAttributedString(string: " " + data[index].korea!))
        koreanLabel.attributedText = attributedString2

        let image: UIImage?
        print("bind")
        print(data[index].isMemorize)
        if data[index].isMemorize {
            image = UIImage(systemName: "checkmark.square", withConfiguration: imageConfig)
            mananger.update()
        } else {
            image = UIImage(systemName: "square", withConfiguration: imageConfig)
            mananger.update()
        }
        isCompleteButton.setImage(image, for: .normal)
    }
    
    func setUpUI() {
        contentView.addSubview(vocaLabel)
        contentView.addSubview(koreanLabel)
        contentView.addSubview(isCompleteButton)

        vocaLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(Constant.defalutPadding)
        }
        koreanLabel.snp.makeConstraints { make in
            make.top.equalTo(vocaLabel.snp.bottom).offset(Constant.defalutPadding)
            make.left.equalTo(vocaLabel.snp.left)
            make.bottom.equalToSuperview().inset(Constant.defalutPadding)
        }
        isCompleteButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(Constant.defalutPadding)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(Constant.screenHeight * 0.05)
        }
    }
    
    @objc func isCompleteButtonTapped() {
        guard let data = data else { return }
        data.isMemorize.toggle()
        var image: UIImage?
        if data.isMemorize {
            image = UIImage(systemName: "checkmark.square", withConfiguration: imageConfig)
        } else {
            image = UIImage(systemName: "square", withConfiguration: imageConfig)
        }
        isCompleteButton.setImage(image, for: .normal)
        mananger.update()
    }
}
