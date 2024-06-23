//
//  Routine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import Foundation
import CoreData

extension Routine {
    
    // MARK: Extra properties
    
    var completedCycles: [Cycle] {
        let context = self.managedObjectContext!
        let fetchRequest: NSFetchRequest<Cycle> = Cycle.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "routine == %@", self),
            NSPredicate(format: "isComplete == %@", NSNumber(value: true))
        ])
        let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
        return results
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateRoutineName()
        try validateCycles()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateRoutineName()
        try validateCycles()
    }
    
    // Checks that the routine name is unique
    private func validateRoutineName() throws {
        let context = self.managedObjectContext!
        let fetchrequest: NSFetchRequest<Routine> = Routine.fetchRequest()
        var results: [Routine] = PersistenceController.fetch(context, fetchRequest: fetchrequest)
        results.removeAll { $0 === self } // remove self
        if results.contains(where: {$0.timePeriodName == self.timePeriodName }) {
            throw ValidationNSErrors.routineNameIsInvalid.toNSError()
        }
    }
    
    // Checks that there arent two active cycles at the same time
    private func validateCycles() throws {
        let completeCycles = self.completedCycles
        let incompleteCycles = self.cycles?.filtered(using: NSPredicate(format: "isComplete == %@", NSNumber(value: false))) ?? []
        // If there are cycles they should all be completed or there should be only one incomplete
        if !(incompleteCycles.count == 0 || incompleteCycles.count == 1) {
            throw ValidationNSErrors.routineHasMultipleIncompleteCycles.toNSError()
        }
    }
    
}
