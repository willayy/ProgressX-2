//
//  Orderable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-28.
//

import Foundation
import CoreData

extension OrderableTimePeriod {
    
    // MARK: Convenience init
    
    // Nothing here.
    
    // MARK: Extra Properties
    
    // Nothing here.
    
    // MARK: Validaiton
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePositionIndexesInSiblings()
    }
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validatePositionIndexesInSiblings()
    }
        
    /// Validates that there are no siblings (objects with the same parent as this one)  with the same positionIndexes.
    private func validatePositionIndexesInSiblings() throws {
        // Forced cast because all orderables have parents.
        let parent = (self as! (any HasParent)).parent
        // Forced cast because all parents have orderables.
        let positionIndexes = (parent as! HasOrderable).getPositionIndexes()
        let hasDuplicates = (positionIndexes.count != Set(positionIndexes).count)
        if hasDuplicates {
            throw ValidationNSErrors.positionIndexIsInvalid.toNSError()
        }
    }
    
    /// Switches to any new positionIndex if  its occupied by another orderable timeperiod
    public func switchPositionIndex(to: Int64) -> Void {
        // Forced cast because all orderables have parents.
        let selfAsHasParent: any HasParent = self as! (any HasParent)
        // Forced cast because all parents have children.
        let parent: any HasChildren = selfAsHasParent.parent as! (any HasChildren)
        // Since self is Orderable all its siblings are as well.
        let siblings = parent.children as! [OrderableTimePeriod]
        
        // Find the sibling with the positionIndex you want to switch to.
        let siblingWithDesiredPI = siblings.first(where: { $0.positionIndex == to })
        
        if siblingWithDesiredPI == nil {
            self.positionIndex = to
        } else {
            siblingWithDesiredPI!.positionIndex = self.positionIndex
            self.positionIndex = to
        }
    }

}
