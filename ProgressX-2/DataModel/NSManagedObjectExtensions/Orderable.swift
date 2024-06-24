//
//  Orderable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-24.
//

import Foundation
import CoreData

extension Orderable {
    
    // MARK: Extra properties
    
    func getNextPositionIndex() -> Int? {
        // Helper method
        func getNextIndex<T: Completeable>(fetchRequest: NSFetchRequest<T>, format: String, arg: CVarArg) -> Int {
            fetchRequest.predicate = NSPredicate(format: "\(format) == %@", arg)
            let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
            let max = results.max {$0.positionIndex > $1.positionIndex}
            return Int(max!.positionIndex + 1)
        }
        
        switch self {
        case is Cycle:
            let instance = self as! Cycle
            return getNextIndex(fetchRequest: TrainingWeek.fetchRequest(), format: "cycle", arg: instance)
        case is TrainingWeek:
            let instance = self as! TrainingWeek
            return getNextIndex(fetchRequest: Session.fetchRequest(), format: "week", arg: instance)
        case is Session:
            let instance = self as! Session
            return getNextIndex(fetchRequest: TrainingSet.fetchRequest(), format: "session", arg: instance)
        default:
            return nil
        }
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validatePositionIndex()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePositionIndex()
    }
    
    // Checks if the parent of this object contains a child with the same postion index as the instance itself
    private func validatePositionIndex() throws {
        
        // Helper method
        func checkForDuplicateIndexes<T: Completeable>(fetchRequest: NSFetchRequest<T>, format: String, arg: CVarArg) throws {
            fetchRequest.predicate = NSPredicate(format: "\(format) == %@", arg)
            var results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
            // Remove the instance from the results, also remove templates
            results.removeAll { $0 === self }
            // Check if the results have a instance with the same positionIndex
            if results.contains(where: { $0.positionIndex == self.positionIndex }) {
                throw ValidationNSErrors.invalidPostionIndex.toNSError()
            }
        }
        
        switch self {
        case is Cycle:
            let instance = self as! Cycle
            try checkForDuplicateIndexes(fetchRequest: Cycle.fetchRequest(), format: "routine", arg: instance.routine!)
        case is TrainingWeek:
            let instance = self as! TrainingWeek
            try checkForDuplicateIndexes(fetchRequest: TrainingWeek.fetchRequest(), format: "cycle", arg: instance.cycle!)
        case is Session:
            let instance = self as! Session
            try checkForDuplicateIndexes(fetchRequest: Session.fetchRequest(), format: "trainingWeek", arg: instance.trainingWeek!)
        case is TrainingSet:
            let instance = self as! TrainingSet
            try checkForDuplicateIndexes(fetchRequest: TrainingSet.fetchRequest(), format: "trainingSession", arg: instance.trainingSession!)
        default:
            break
        }
    }

}
