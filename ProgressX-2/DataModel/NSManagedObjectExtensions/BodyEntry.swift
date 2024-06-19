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
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try self.validateProfile()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try self.validateProfile()
    }
    
    private func validateProfile() throws {
        if self.profile == nil {
            throw ProgressXNSErrors.bodyEntryProfileIsNil.toNSError()
        }
    }
    
}
