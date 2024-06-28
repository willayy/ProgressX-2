//
//  Routine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import Foundation
import CoreData

extension Routine: HasOrderable {
    
    // MARK: Extra properties
    
    var creationDateString: String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if self.createdOnDate != nil {
            return df.string(from: self.createdOnDate!)
        }
        
        else {
            return nil
        }
    }
    
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
    
    
    /// Gets the next available
    /// - Returns: An Int64 that is a valid positionIndex
    func getNextPositionIndex() -> Int64 {
        let cycles: [Cycle] = self.cycles?.allObjects as! [Cycle]
        let max = cycles.max {$0.positionIndex > $1.positionIndex}
        return Int64(max?.positionIndex ?? 0 + 1)
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateRoutineName()
        try validatePositionIndexes()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateRoutineName()
        try validatePositionIndexes()
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
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let cycles: [Cycle] = self.cycles?.allObjects as! [Cycle]
        let groupedBy = Dictionary(grouping: cycles, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
        
}
