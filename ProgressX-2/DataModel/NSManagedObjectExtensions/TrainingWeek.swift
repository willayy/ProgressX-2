//
//  Week.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation

extension TrainingWeek {
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateIsComplete()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateIsComplete()
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error.
        if self.isComplete && self.sessions == nil {
            throw NSError(
                domain: "CoreDataErrorDomain",
                code: 9991,
                userInfo: [NSLocalizedDescriptionKey: "Week can't be complete without any sessions"]
            )
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
            throw NSError(
                domain: "CoreDataErrorDomain",
                code: 9992,
                userInfo: [NSLocalizedDescriptionKey: "Week can't be complete when its sessions aren't"]
            )
        }
    }
}
