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
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textColor = .black
        return label
    }()
    private let allCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .black
        return label
    }()
    private var count: Int = 0
    private let endValue: Double
    private let startValue: Double = 0
    private let duration: CGFloat = 1
    private let quizRate: CGFloat
    private var displayLink: CADisplayLink?
    private var animationStartDate: Date? = nil


    init(correctRate: CGFloat, allWordCount: Int, isMemorizeCount: Int) {
        quizRate = correctRate
        endValue = correctRate * 100
        
        self.correctRateLabel.text = "0"
        self.allCountLabel.text = "\(isMemorizeCount) / \(allWordCount)"
        
        super.init(frame: .zero)
        
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
        let bezierPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        calayer.path = bezierPath.cgPath
        calayer.strokeColor = UIColor.red.cgColor
        calayer.fillColor = UIColor.clear.cgColor
        calayer.lineWidth = 8
        calayer.lineCap = .round
        
        let caAnimation = CABasicAnimation(keyPath: "strokeEnd")
        caAnimation.fromValue = 0
        caAnimation.toValue = quizRate
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
        animationStartDate = Date()
        displayLink?.add(to: .main, forMode: .default)
    }
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink = nil
    }
    
    @objc private func countLabelUpdate() {
        guard let animationStartDate else { return }
        let now = Date()
        let time = now.timeIntervalSince(animationStartDate)
        
        if time > duration {
            stopDisplayLink()
            correctRateLabel.text = "\(Int(endValue))"
            return
        }
        let percentage = time / duration
        let value = percentage * (endValue - startValue)
        count = Int(value)
        correctRateLabel.text = "\(count)"
    }
}
