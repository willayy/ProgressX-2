//
//  Session.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation

extension Session {
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error
        if self.isComplete && self.sets == nil {
            throw NSError(
                domain: "CoreDataErrorDomain",
                code: 9996,
                userInfo: [NSLocalizedDescriptionKey: "Session can't be complete without any sets"]
            )
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
            throw NSError(
                domain: "CoreDataErrorDomain",
                code: 9997,
                userInfo: [NSLocalizedDescriptionKey: "Session can't be complete when its sets aren't"]
            )
        }
    }
}
