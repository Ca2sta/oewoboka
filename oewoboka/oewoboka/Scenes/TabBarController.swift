//
//  ViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllerSetting()
    }

    private func viewControllerSetting() {
        let vc1 = UINavigationController(rootViewController: VocaListViewController())
        let vc2 = UINavigationController(rootViewController: AddVocaViewController())
        let vc3 = UINavigationController(rootViewController: FeatureViewController())

        self.setViewControllers([vc1, vc2, vc3], animated: false)
    }
}
