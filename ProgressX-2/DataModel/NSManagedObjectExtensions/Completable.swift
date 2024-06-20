//
//  Completable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension Completeable {
    
    //MARK: Extra properties
    
    var completionDateString: String? {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        
        if self.completedOnDate != nil {
            return df.string(from: self.completedOnDate!)
        }
        
        else {
            return nil
        }
    }
    
    //MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
        try validatePositionIndex()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
        try validatePositionIndex()
    }
    
    private func validateIsComplete() throws {
        if self.isComplete && self.completedOnDate == nil {
            throw NSValidationErrors.completeWithoutCompletionDate.toNSError()
        }
    }
    
    // Checks if the parent of this object contains a child with the same postion index as the instance itself
    private func validatePositionIndex() throws {
        
        // Helper method
        func checkForDuplicateIndexes<T: Completeable>(fetchRequest: NSFetchRequest<T>, format: String, arg: CVarArg) throws {
            fetchRequest.predicate = NSPredicate(format: "\(format) == %@", arg)
            var results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
            // Remove the instance from the results
            results.removeAll { $0 === self }
            // Check if the results have a instance with the same positionIndex
            if results.contains(where: { $0.positionIndex == self.positionIndex }) {
                throw NSValidationErrors.invalidPostionIndex.toNSError()
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
