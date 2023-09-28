//
//  FTModalMiddleView.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/27.
//

import UIKit

final class FTModalMiddleView: UIView {

    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        return view
    }()
    
    private let contentView = UIView()
    
    let rangeView = QuizSettingView(
        title: "문제 범위",
        description: "여러 단어장을 선택할 수 있어요",
        type: .range
    )
    
    let typeView = QuizSettingView(
        title: "문제 타입",
        description: "공부하고 싶은 항목을 선택해 주세요",
        type: .type
    )
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension FTModalMiddleView {
    
    // MARK: - SetUp

    func setUp(){
        setUpScrollView()
        setUpContentView()
        setUpRangeView()
        setUpTypeView()
    }
    
    func setUpScrollView() {
        self.addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpContentView() {
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
    }
    
    func setUpRangeView() {
        contentView.addSubview(rangeView)
        rangeView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
        }
    }
    
    func setUpTypeView() {
        contentView.addSubview(typeView)
        typeView.snp.makeConstraints { make in
            make.top.equalTo(rangeView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
    
}
