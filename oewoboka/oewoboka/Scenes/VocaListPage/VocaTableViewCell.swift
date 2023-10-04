//
//  VocaTableViewCell.swift
//  oewoboka
//
import UIKit
import SnapKit

class VocaTableViewCell: UITableViewCell {
    static let identifier = "VocaCell"
    var buttonState = 2
    var data: WordEntity?
    let dateLabel : UILabel = {
        let label = UILabel()
        label.font = Typography.body2.font
        return label
    }()
    let isCompleteButton: UIButton = {
        let button = UIButton()
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 300, weight: .light)
        let image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)

        button.setImage(image, for: .normal)
        button.imageView?.contentMode = .scaleAspectFill

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
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func bind(data: WordEntity) {
        self.data = data
        vocaLabel.text = data.english
        koreanLabel.text = data.korea
        
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 300, weight: .light)
        let image: UIImage?
        if data.isMemorize {
            print("isMemorize's status:\(data.isMemorize)")
            image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
        } else {
            print("isMemorize's status:\(data.isMemorize)")
            image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)
        }
        isCompleteButton.setImage(image, for: .normal)
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
            make.height.width.equalTo(45)
        }
        vocaLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(-15)
            make.left.equalToSuperview().offset(10)
            make.height.equalTo(30)
        }
        koreanLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().offset(-10)
            make.top.equalTo(vocaLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
    }
    
    @objc func isCompleteButtonTapped() {
        let imageConfig = UIImage.SymbolConfiguration(pointSize: 300, weight: .light)
        guard let data = data else { return }
        
        switch buttonState {
        case 1:
            let image = UIImage(systemName: "checkmark.square.fill", withConfiguration: imageConfig)
            isCompleteButton.setImage(image, for: .normal)
            data.isMemorize = true
            print(data.isMemorize)

            buttonState = 2
        case 2:
            let image = UIImage(systemName: "xmark.square.fill", withConfiguration: imageConfig)
            isCompleteButton.setImage(image, for: .normal)
            data.isMemorize = false
            print(data.isMemorize)
            buttonState = 1
        default:
            break
        }
    }
}
