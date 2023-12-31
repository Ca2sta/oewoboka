//
//  Protocol.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/10/02.
//

import Foundation
import UIKit

protocol ViewHasButton: UIViewController {
    func didTappedButton(button: UIButton)
}

protocol ViewHasSlider: UIViewController {
    func didSlideSlider(_ slider: UISlider)
}
