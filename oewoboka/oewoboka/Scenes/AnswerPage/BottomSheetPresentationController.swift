//
//  BottomSheetPresentationController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/09/29.
//

import UIKit
import SnapKit

class BottomSheetPresentationController: UIPresentationController {

    override var frameOfPresentedViewInContainerView: CGRect {
        guard var frame = containerView?.frame else {
            return .zero
        }
        frame.origin.y = Constant.screenHeight * 0.2
        frame.size.height = Constant.screenHeight * 0.8
        return frame
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        
        guard let containerView else { return }
        
        containerView.backgroundColor = .clear.withAlphaComponent(0.5)
    }
}
