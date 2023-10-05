//
//  Int.swift
//  oewoboka
//
//  Created by 김도현 on 2023/10/05.
//

import Foundation

extension Int {
    func stringFromTime() -> String {

        let time = self

        let seconds = time % 60
        let minutes = (time / 60) % 60
        if minutes == 0 {
            return "\(seconds)초"
        }
        let hours = (time / 3600)
        if hours == 0 {
            return "\(minutes)분\(seconds)초"
        }
        return "\(hours)시\(minutes)분\(seconds)초"

    }
}
