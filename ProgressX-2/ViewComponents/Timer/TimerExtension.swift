//
//  TimerEc.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-24.
//

import Foundation

extension Int {
    var asTimestamp: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60

        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
}
