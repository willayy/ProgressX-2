//
//  BodyEntry.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import Foundation

extension BodyEntry {
    
    /// Formatted weightLoad String from PR
    /// - Returns: String(Double) formatted to two decimal points.
    @objc public func bodyWeightString() -> String {
        return String(format: "%.2f", self.bodyWeight)
    }
    
}
