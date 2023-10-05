//
//  ResultView.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class CircleProgressBar: UIView {
    
    enum ResultType {
        case number // 숫자와 밑에 count가 보이는 형태의 ResultView (예:30)
        case percent // 숫자와 %가 같이 보이는 형태의 ResultView (예:30%)
    }
    let correctRateLabel: UILabel = {
        let label = UILabel()
        label.font = Typography.title1.font
        label.textColor = .black
        return label
    }()
    private let allCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .regular)
        label.textColor = .black
        return label
    }()
    private let type: ResultType
    private var count: Int = 0
    private var endValue: Double = 0
    private let startValue: Double = 0
    private var quizRate: CGFloat = 0
    private var displayLink: CADisplayLink?
    private var animationStartDate: Date? = nil
    private var animationLayer: CAShapeLayer? = nil
    
    private var correctRate: CGFloat = 0 {
        didSet {
            self.quizRate = correctRate
            self.endValue = correctRate * 100
        }
    }
    // 애니메이션 시간
    var duration: CGFloat = 1
    // 테두리 굵기
    var resultViewLineWidth: CGFloat = 3
    // 에니메이션이 되는 라인의 굵기
    var progressBarLineWidth: CGFloat = 8
    var lineColor: UIColor = UIColor.red
    var fillColor: CGColor = UIColor.clear.cgColor

    init(type: ResultType) {
        self.type = type
        self.correctRateLabel.text = "0"
        if type == .percent {
            self.correctRateLabel.text? += "%"
            allCountLabel.isHidden = true
        }
        
        super.init(frame: .zero)
        
        setup()
    }

    convenience init(correctRate: CGFloat, type: ResultType) {
        self.init(type: type)
        
        quizRate = correctRate
        endValue = correctRate * 100
        
        setup()
    }
    
    convenience init(correctRate: CGFloat, type: ResultType, allWordCount: Int, isMemorizeCount: Int) {
        self.init(correctRate: correctRate, type: type)
        self.allCountLabel.text = "\(isMemorizeCount) / \(allWordCount)"
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension CircleProgressBar {
    func setup() {
        addViews()
        autoLayoutSetup()
    }
    func addViews() {
        addSubview(correctRateLabel)
        addSubview(allCountLabel)
    }
    
    func autoLayoutSetup() {
        if type == .number {
            correctRateLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.bottom.equalTo(snp.centerY)
            }
            allCountLabel.snp.makeConstraints { make in
                make.centerX.equalToSuperview()
                make.top.equalTo(correctRateLabel.snp.bottom).offset(12)
            }
        } else {
            correctRateLabel.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
        }
    }
}

//MARK: Animation
extension CircleProgressBar {
    
    func progressBarSetupAnimation(rate: CGFloat) {
        if let animationLayer {
            animationLayer.removeFromSuperlayer()
        }
        
        layoutIfNeeded()
        
        correctRate = rate
        
        let bezierPathTest = UIBezierPath(ovalIn: bounds)
        let progressBar = CAShapeLayer()
        progressBar.path = bezierPathTest.cgPath
        progressBar.fillColor = fillColor
        progressBar.strokeColor = lineColor.withAlphaComponent(0.3).cgColor
        progressBar.lineWidth = resultViewLineWidth
        layer.addSublayer(progressBar)
        
        let arcCenter = CGPoint(x: bounds.width/2, y: bounds.height/2)
        let radius = bounds.width/2
        let calayer = CAShapeLayer()
        let bezierPath = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: -0.5 * CGFloat.pi, endAngle: 1.5 * CGFloat.pi, clockwise: true)
        calayer.path = bezierPath.cgPath
        calayer.strokeColor = lineColor.cgColor
        calayer.fillColor = fillColor
        
        calayer.lineWidth = progressBarLineWidth
        calayer.lineCap = .round
        
        let caAnimation = CABasicAnimation(keyPath: "strokeEnd")
        caAnimation.fromValue = 0
        caAnimation.toValue = quizRate
        caAnimation.duration = duration
        caAnimation.fillMode = .forwards
        caAnimation.isRemovedOnCompletion = false
        calayer.add(caAnimation, forKey: nil)
        
        startDisplayLink()
        
        self.animationLayer = calayer
        
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
            correctRateLabel.text = type == .number ? "\(Int(endValue))" : "\(Int(endValue))%"
            return
        }
        let percentage = time / duration
        let value = percentage * (endValue - startValue)
        count = Int(value)
        correctRateLabel.text = type == .number ? "\(count)" : "\(count)%"
    }
}
