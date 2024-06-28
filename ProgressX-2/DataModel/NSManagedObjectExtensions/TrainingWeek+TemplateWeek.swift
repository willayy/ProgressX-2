//
//  Week.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation
import CoreData

extension TrainingWeek: HasOrderable {
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sessions: [Session] = self.sessions?.allObjects as! [Session]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
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
        let sessions: [Session] = self.sessions?.allObjects as! [Session]
        let groupedBy = Dictionary(grouping: sessions, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error.
        if self.isComplete && self.sessions == nil {
            throw ValidationNSErrors.weekCompleteWithNoSessions.toNSError()
        }
        
        // If session is complete but it's sets arent throw an error.
        var completedSessions: Int = 0
        let sessions = self.sessions!.allObjects as! [Session]
        
        // Count completed sessions.
        for session in sessions {
            if session.isComplete {
                completedSessions += 1
            }
        }
        
        // Throw if true.
        if self.isComplete && completedSessions != sessions.count {
            throw ValidationNSErrors.weekCompleteWithUncompleteSessions.toNSError()
        }
    }
}

extension TemplateWeek: HasOrderable {
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sessions: [TemplateSet] = self.sessions?.allObjects as! [TemplateSet]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
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
        let sessions: [TemplateSession] = self.sessions?.allObjects as! [TemplateSession]
        let groupedBy = Dictionary(grouping: sessions, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
}
