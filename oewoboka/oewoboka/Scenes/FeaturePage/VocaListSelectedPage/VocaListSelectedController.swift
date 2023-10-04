//
//  VocaListSelectedController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/10/01.
//

import UIKit
import SnapKit

final class VocaListSelectedController: UIViewController {

    private let topView = PageTopView(title: "단어장 선택")
    
    private let viewModel: FTOPViewModel
    
    let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        view.backgroundColor = .cyan
        return view
    }()
    
    init(viewModel: FTOPViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension VocaListSelectedController {
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUp()
    }
}

private extension VocaListSelectedController {
    func setUp() {
        setUpTopView()
        setUpCollectionView()
    }
    func setUpTopView() {
        view.addSubview(topView)
        topView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
        }
    }
    func setUpCollectionView() {
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(topView.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }
    }
}
