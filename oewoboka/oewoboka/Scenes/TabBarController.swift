//
//  ViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/25.
//

import UIKit

final class TabBarViewController: UITabBarController {

    let manager = VocabularyRepository.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if manager.allFetch().isEmpty {
            manager.create(title: "Defalut")
        }
        viewControllerSetting()
        
    }

    private func viewControllerSetting() {
        let vc1 = UINavigationController(rootViewController: VocaListViewController())
        vc1.tabBarItem = UITabBarItem(
            title: "단어장",
            image: UIImage(systemName: "book.closed"),
            selectedImage: UIImage(systemName: "book.closed.fill")
        )
        let vc2 = UINavigationController(rootViewController: AddWordViewController(vocabulary: manager.allFetch()[0]))
        vc2.tabBarItem = UITabBarItem(
            title: "추가하기",
            image: UIImage(systemName: "plus.app"),
            selectedImage: UIImage(systemName: "plus.app.fill")
        )
        let vc3 = UINavigationController(rootViewController: FeatureViewController())
        vc3.tabBarItem = UITabBarItem(
            title: "학습하기",
            image: UIImage(systemName: "book"),
            selectedImage: UIImage(systemName: "book.fill")
        )

        self.setViewControllers([vc1, vc2, vc3], animated: true)
        tabBar.tintColor = .systemPink
    }
}
