//
//  Week.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation
import CoreData

extension TrainingWeek: HasOrderable, HasCompleteable {
    
    // MARK: Convenience init
    convenience init(
        _ context: NSManagedObjectContext,
        trainingCycle: TrainingCycle,
        templateWeek: TemplateWeek,
        name: String = "",
        description: String = ""
    ) {
        self.init(context: context)
        self.trainingCycle = trainingCycle
        self.templateWeek = templateWeek
        let positionIndex = trainingCycle.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "Week \(positionIndex)" : name
        let routineName = trainingCycle.routine!.timePeriodName!
        self.timePeriodDescription = (description == "") ? "Week in \(routineName)" : description
        self.startedOnDate = Date()
        trainingCycle.addToTrainingWeeks(self)
    }
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sessions: [TrainingSession] = self.trainingSessions?.allObjects as! [TrainingSession]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
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
    
    internal func childrenAreComplete() -> Bool {
        self.trainingSessions!.allSatisfy { trainingSession in
            (trainingSession as! TrainingSession).isComplete
        }
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let sessions: [TrainingSession] = self.trainingSessions?.allObjects as! [TrainingSession]
        let groupedBy = Dictionary(grouping: sessions, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error.
        if self.isComplete && self.trainingSessions!.allObjects.isEmpty {
            throw ValidationNSErrors.weekCompleteWithNoSessions.toNSError()
        }
        
        // If week is complete but it's sets arent throw an error.
        // Throw if true.
        if self.isComplete && !self.childrenAreComplete() {
            throw ValidationNSErrors.weekCompleteWithUncompleteSessions.toNSError()
        }
    }
    
    private func validateCompleteables() throws {
        let sessions = self.trainingSessions!.allObjects as! [TrainingSession]
        // If there are no weeks abort.
        if sessions.count == 0 { return }
        // Else check if count of completed weeks is equal to all weeks.
        let completedSessions = sessions.filter { $0.isComplete }
        if completedSessions.count == sessions.count && !self.isComplete {
            throw ValidationNSErrors.weekInCompleteWithCompleteSessions.toNSError()
        }
    }
    
    
}
