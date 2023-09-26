//
//  FeatureCellModels.swift
//  oewoboka
//
//  Created by SeoJunYoung on 2023/09/25.
//

import Foundation
import UIKit

struct FeatureCellModel {
    var image: UIImage?
    var title: String
    var description: String { "\(self.title)를 하며 단어를 외워요!" }
}
