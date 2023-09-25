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
        case arrow
    }
    
    // MARK: - Property
    private var arrowImageView: UIImageView? = nil
    
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
            if let arrowImageView { arrowImageView.tintColor = isHighlighted ? .systemRed : .black }
        }
    }
    
    var verticalPadding: CGFloat = 4
    var horizontalPadding: CGFloat = 8
    var spacing: CGFloat = 8
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
            let leftEdgeInset = bounds.width/2 - (titleLabel?.bounds.width ?? 0)
            titleEdgeInsets.left = leftEdgeInset
        case .left:
            titleEdgeInsets.left = spacing
        case .noBorder:
            layer.borderWidth = 0
            titleEdgeInsets.left = spacing
        case .arrow:
            titleEdgeInsets.left = spacing
            if arrowImageView == nil { addArrowImageView() }
        }
    }
    
    private func makeRound() {
        layer.cornerRadius = 5
    }
    
    private func makeBorder() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.black.cgColor
    }
    
    private func addArrowImageView() {
        self.arrowImageView = createArrowImageView()
        addSubview(arrowImageView!)
        
        arrowImageView!.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(8)
        }
    }
    
    private func createArrowImageView() -> UIImageView {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.tintColor = .black
        return imageView
    }
}
