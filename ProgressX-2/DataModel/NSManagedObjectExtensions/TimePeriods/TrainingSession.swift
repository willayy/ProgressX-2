//
//  Session.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension TrainingSession: HasOrderable {
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sets: [TrainingSet] = self.trainingSets?.allObjects as! [TrainingSet]
        let max = sets.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
        try validatePositionIndexes()
        try validateCompleteables()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
        try validatePositionIndexes()
        try validateCompleteables()
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let sets: [TrainingSet] = self.trainingSets?.allObjects as! [TrainingSet]
        let groupedBy = Dictionary(grouping: sets, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error
        if self.isComplete && self.trainingSets!.allObjects.isEmpty {
            throw ValidationNSErrors.sessionCompleteWithNoSets.toNSError()
        }
        
        // If session is complete but it's sets arent throw an error
        var completedSets: Int = 0
        let sets = self.trainingSets!.allObjects as! [TrainingSet]
        
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
    
    private func validateCompleteables() throws {
        let sets = self.trainingSets!.allObjects as! [TrainingSet]
        // If there are no weeks abort.
        if sets.count == 0 { return }
        // Else check if count of completed weeks is equal to all weeks.
        let completedSets = sets.filter { $0.isComplete }
        if completedSets.count == sets.count && !self.isComplete {
            throw ValidationNSErrors.sessionIncompleteWithCompleteSets.toNSError()
        }
    }
    
}
