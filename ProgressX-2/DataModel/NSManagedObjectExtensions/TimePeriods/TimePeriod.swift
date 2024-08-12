//
//  TimePeriod.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-11.
//

import Foundation

#warning("TODO: Go through all files in the DataModel package and make sure everything is commented, and that everything follows the naming conventions.")

extension TimePeriod {
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        if self is HasOrderable {
            try validatePositionIndexesInChildren()
        }
    }
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        if self is HasOrderable {
            try validatePositionIndexesInChildren()
        }
    }
    
    /* Duplicate positionindexes in parents with orderable children is handled here */
    
    /// Validates that there are no children in Objects who have Orderables (objects with positionIndexes)
    private func validatePositionIndexesInChildren() throws {
        let selfAsHasOrderable: HasOrderable = self as! HasOrderable
        let positionIndexes = selfAsHasOrderable.getPositionIndexes()
        let hasDuplicates = positionIndexes.count != Set(positionIndexes).count
        if hasDuplicates {
            throw ValidationNSErrors.positionIndexIsInvalid.toNSError()
        }
    }
        
}
