//
//  VocaListSelectedController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/10/01.
//

import UIKit

final class VocaListSelectedController: UIViewController {

    private let viewModel: FTOPViewModel
    
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
    }
}
