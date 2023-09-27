//
//  DefaultButton.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/26.
//

import UIKit

final class DefaultButton: UIButton {
    
    enum ButtonType {
        case center
        case noBorder
        case left
        case rightImage(UIImage?)
    }
    
    // MARK: - Property
    private var trailingImageView: UIImageView? = nil
    
    var text: String? = nil {
        didSet {
            setTitle(text, for: .normal)
        }
    }
    var image: UIImage? = nil {
        didSet {
            setupImage()
        }
    }
    
    var type: ButtonType = .center
    
    override var isHighlighted: Bool {
        didSet {
            imageView?.tintColor = isHighlighted ? .systemRed : .black
            layer.borderColor = isHighlighted ? UIColor.systemRed.cgColor : UIColor.black.cgColor
            if let trailingImageView { trailingImageView.tintColor = isHighlighted ? .systemRed : .black }
        }
    }
    
    var verticalPadding: CGFloat = 4
    var horizontalPadding: CGFloat = 12
    var spacing: CGFloat = 8
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageViewSetup()
        setTitle()
        makeRound()
        makeBorder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        typeSetup()
    }
    
}

// MARK: - InitUI
extension DefaultButton {
        
    private func imageViewSetup() {
        imageView?.contentMode = .scaleAspectFill
    }
    private func setTitle() {
        titleLabel?.font = Typography.body1.font
        setTitleColor(UIColor.black, for: .normal)
        setTitleColor(UIColor.systemRed, for: .highlighted)
    }
    
    private func setupImage() {
        imageView?.tintColor = .black
        setImage(image, for: .normal)
        setImage(image, for: .highlighted)
    }
    
    private func typeSetup() {
        contentHorizontalAlignment = .left
        contentEdgeInsets = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        switch type {
        case .center:
            let leftEdgeInset = bounds.width/2 - (titleLabel?.bounds.width ?? 0)/2 - (imageView?.bounds.width ?? 0) - horizontalPadding
            titleEdgeInsets.left = leftEdgeInset
        case .left:
            titleEdgeInsets.left = spacing
        case .noBorder:
            layer.borderWidth = 0
            titleEdgeInsets.left = spacing
        case .rightImage(let rightImage):
            titleEdgeInsets.left = spacing
            if trailingImageView == nil { addArrowImageView(rightImage) }
        }
    }
    
    private func makeRound() {
        layer.cornerRadius = 5
    }
    
    private func makeBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    private func addArrowImageView(_ rightImage: UIImage?) {
        self.trailingImageView = createArrowImageView(rightImage)
        addSubview(trailingImageView!)
        
        trailingImageView!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
    }
    
    private func createArrowImageView(_ rightImage: UIImage?) -> UIImageView {
        let imageView = UIImageView()
        imageView.image = rightImage == nil ? UIImage(systemName: "chevron.right") : rightImage
        imageView.tintColor = .black
        return imageView
    }
}
