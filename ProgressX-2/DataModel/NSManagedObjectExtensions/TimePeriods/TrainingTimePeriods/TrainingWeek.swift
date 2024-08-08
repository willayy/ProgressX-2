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
        templateWeek: TemplateWeek
    ) {
        self.init(context: context)
        self.trainingCycle = trainingCycle
        self.templateWeek = templateWeek
        let positionIndex = trainingCycle.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = templateWeek.timePeriodName
        self.timePeriodDescription = templateWeek.timePeriodDescription
        self.startedOnDate = Date()
        trainingCycle.addToTrainingWeeks(self)
    }
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sessions: [TrainingSession] = self.trainingSessions?.allObjects as! [TrainingSession]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    public func getNextTrainingSession() -> TrainingSession? {
        let allSessions = self.trainingSessions!.allObjects as! [TrainingSession]
        let orderedIncompleteSessions: [TrainingSession] = allSessions
            .filter { session in !session.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteSessions.first
    }
    
    public func getAllTrainingSessions() -> [TrainingSession] {
        let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trainingWeek == %@", self)
        let context = self.managedObjectContext!
        let sessions = PersistenceController.fetch(context, fetchRequest: fetchRequest)
        return sessions
    }
    
    public func getProgress() -> Double {
        let allsession = self.getAllTrainingSessions()
        let completedSession = allsession.filter({ $0.isComplete })
        let numberOfSessions = Double(allsession.count)
        let numberOfCompletedSessions = Double(completedSession.count)
        if numberOfSessions == 0 { return 0 }
        else { return (numberOfCompletedSessions / numberOfSessions) }
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
    
    internal func childrenAreComplete() -> Bool {
        if self.trainingSessions!.allObjects.isEmpty {
            return false
        } else {
          return self.trainingSessions!.allSatisfy {
              trainingSession in
                (trainingSession as! TrainingSession).isComplete
            }
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
        if self.isComplete && !self.childrenAreComplete() {
            throw ValidationNSErrors.weekCompleteWithUncompleteSessions.toNSError()
        }
        
        // If incomplete but with complete sessions
        if !self.isComplete && self.childrenAreComplete() {
            throw ValidationNSErrors.weekInCompleteWithCompleteSessions.toNSError()
        }
    }
    
}
