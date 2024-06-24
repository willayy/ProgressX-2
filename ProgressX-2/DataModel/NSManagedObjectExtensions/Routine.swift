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
    
    func getNextPositionIndex() -> Int {
        let fetchRequest: NSFetchRequest<Cycle> = Cycle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "coutine == %@", self)
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        let max = results.max {$0.positionIndex > $1.positionIndex}
        return Int(max!.positionIndex + 1)
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateRoutineName()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateRoutineName()
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
        
}
