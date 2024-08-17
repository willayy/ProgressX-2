//
//  Orderable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-28.
//

import Foundation
import CoreData

extension OrderableTimePeriod {
    
    // MARK: Extra Properties
    
    // Nothing here
    
    // MARK: Validaiton
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try revalidateParentChildRelationships()
    }
    
    
    /// Notifies the parent that it should evalidate its "parent" and "child" relationship when positionIndex changes in a child.
    private func revalidateParentChildRelationships() throws {
        let changedValues = changedValues()
        if changedValues.keys.contains("positionIndex") {
            let selfAsHasParent: any HasParent = self as! any HasParent
            let parentAsNsManagedObject: NSManagedObject = selfAsHasParent.parent as! NSManagedObject
            try parentAsNsManagedObject.validateForUpdate()
        }
    }
    
    public func switchPositionIndex(to: Int64) -> Void {
        #warning("TODO: Implement, this should cause the parent to revalidate")
    }

}
