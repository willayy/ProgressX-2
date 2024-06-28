//
//  Session.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension Session: HasOrderable {
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let fetchRequest: NSFetchRequest<TrainingSet> = TrainingSet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "session == %@", self)
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        let max = results.max {$0.positionIndex > $1.positionIndex}
        return Int64(max?.positionIndex ?? 0 + 1)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
        try validatePositionIndexes()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
        try validatePositionIndexes()
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let fetchRequest: NSFetchRequest<TrainingSet> = TrainingSet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "session == %@", self)
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        let groupedBy = Dictionary(grouping: results, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error
        if self.isComplete && self.sets == nil {
            throw ValidationNSErrors.sessionCompleteWithNoSets.toNSError()
        }
        
        // If session is complete but it's sets arent throw an error
        var completedSets: Int = 0
        let sets = self.sets!.allObjects as! [TrainingSet]
        
        // Count completed sets
        for set in sets {
            if set.isComplete {
                completedSets += 1
            }
        }
        
        // Throw if true
        if self.isComplete && completedSets != sets.count {
            throw ValidationNSErrors.sessionCompleteWithUncompleteSets.toNSError()
        }
    }
}

extension TemplateSession: HasOrderable {
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let fetchRequest: NSFetchRequest<TemplateSession> = TemplateSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "session == %@", self)
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        let max = results.max {$0.positionIndex > $1.positionIndex}
        return Int64(max?.positionIndex ?? 0 + 1)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validatePositionIndexes()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePositionIndexes()
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let fetchRequest: NSFetchRequest<TemplateSet> = TemplateSet.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "session == %@", self)
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        let groupedBy = Dictionary(grouping: results, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
    
}
