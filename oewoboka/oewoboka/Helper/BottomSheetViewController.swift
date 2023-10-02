//
//  BottomSheetViewController.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/02.
//

import UIKit

class BottomSheetViewController: UIViewController {
    
    private var isDismissTouch: Bool = false
    private let originY: CGFloat
    
    init(originY: CGFloat) {
        self.originY = originY
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

// MARK: TouchEvent
extension BottomSheetViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let window = UIApplication.shared.windows.first,
              let location = touches.first?.location(in: window),
              location.y <= originY + 40 else { return }
        isDismissTouch = true
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let window = UIApplication.shared.windows.first
        guard let location = touches.first?.location(in: window),
            isDismissTouch else { return }
        guard location.y > originY else {
            view.frame.origin.y = originY
            return
        }
        view.frame.origin.y = location.y
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard isDismissTouch,
              let window = UIApplication.shared.windows.first,
              let touch = touches.first else { return }
        
        let previousLocation = touch.previousLocation(in: window)
        let location = touch.location(in: window)
        
        let dismissY = originY + 200
        let isFasterDown = (location.y - previousLocation.y) >= 7
        
        if location.y >= dismissY { dismiss(animated: true) }
        else if isFasterDown { dismiss(animated: true) }
        else {
            isDismissTouch = false
            UIView.animate(withDuration: 0.1) {
                self.view.frame.origin.y = self.originY
            }
        }
    }
}
