//
//  FTOPViewController.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/26.
//

import UIKit

class FTOPViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        if let sheetPresentationController = sheetPresentationController {
            sheetPresentationController.detents = [.medium(), .large()]
        }
    }

}
