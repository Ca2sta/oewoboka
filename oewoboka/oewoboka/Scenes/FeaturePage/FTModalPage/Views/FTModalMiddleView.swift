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
    
    lazy var rangeView = QuizSettingView(
        title: viewModel.rangeViewTitle,
        description: viewModel.rangeViewDescription,
        type: .range,
        viewModel: viewModel
    )
    
    lazy var typeView = QuizSettingView(
        title: viewModel.typeViewTitle,
        description: viewModel.typeViewDescription,
        type: .type,
        viewModel: viewModel
    )
    
    lazy var countView = QuizCountView(viewModel: viewModel)
    
    private var viewModel = FTOPViewModel()
    
    init(viewModel: FTOPViewModel) {
        self.viewModel = viewModel
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
        setUpCountView()
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
            make.left.right.equalToSuperview()
        }
    }
    
    func setUpCountView() {
        contentView.addSubview(countView)
        countView.snp.makeConstraints { make in
            make.top.equalTo(typeView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
