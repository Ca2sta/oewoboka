//
//  ResultView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class ResultView: UIView {
    
    private let correctRateLabel: UILabel = {
        let label = UILabel()
        label.text = "50"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let allCountLabel: UILabel = {
        let label = UILabel()
        label.text = "2 / 4"
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .black
        return label
    }()
    private var count: Int = 0
    private let endValue: Int = 50
    private let duration: CGFloat = 2
    private let quizRate: CGFloat = 0.5
    private var displayLink: CADisplayLink?


    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension ResultView {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    func addViews() {
        addSubview(correctRateLabel)
        addSubview(allCountLabel)
    }
    
    func autoLayoutSetup() {
        correctRateLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(snp.centerY)
        }
        allCountLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(correctRateLabel.snp.bottom).offset(12)
        }
    }
}

//MARK: Animation
extension ResultView {
    
    func progressBarSetupAnimation() {
        layoutIfNeeded()
        
        let bezierPathTest = UIBezierPath(ovalIn: bounds)
        let progressBar = CAShapeLayer()
        progressBar.path = bezierPathTest.cgPath
        progressBar.fillColor = UIColor.clear.cgColor
        progressBar.strokeColor = UIColor.red.withAlphaComponent(0.3).cgColor
        progressBar.lineWidth = 3
        layer.addSublayer(progressBar)
        
        let arcCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = bounds.width/2
        let calayer = CAShapeLayer()
        let bezierPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: -.pi / 2, endAngle: quizRate * CGFloat.pi, clockwise: true)
        calayer.path = bezierPath.cgPath
        calayer.strokeColor = UIColor.red.cgColor
        calayer.fillColor = UIColor.clear.cgColor
        calayer.lineWidth = 8
        calayer.lineCap = .round
        
        let caAnimation = CABasicAnimation(keyPath: "strokeEnd")
        caAnimation.toValue = 1
        caAnimation.fromValue = 0
        caAnimation.duration = duration
        caAnimation.fillMode = .forwards
        caAnimation.isRemovedOnCompletion = false
        calayer.add(caAnimation, forKey: nil)
        
        startDisplayLink()
        
        layer.addSublayer(calayer)
    }
    
    private func startDisplayLink() {
        stopDisplayLink()
        displayLink = CADisplayLink(target: self, selector: #selector(countLabelUpdate))
        displayLink?.preferredFramesPerSecond = 100
        displayLink?.add(to: .main, forMode: .default)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func countLabelUpdate() {
        count += 1
        if count >= endValue { stopDisplayLink() }
        correctRateLabel.text = "\(count)"
    }
}
