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
    
    /// The next trainingSession in the order of this TrainingWeek
    public var nextTrainingSession: TrainingSession? {
        let allSessions = self.trainingSessions!.allObjects as! [TrainingSession]
        let orderedIncompleteSessions: [TrainingSession] = allSessions
            .filter { session in !session.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteSessions.first
    }
    
    /// All TrainingSessions in this TrainingWeek
    public var allTrainingSessions: [TrainingSession] {
        let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trainingWeek == %@", self)
        let context = self.managedObjectContext!
        let sessions = PersistenceController.fetch(context, fetchRequest: fetchRequest)
        return sessions
    }
    
    /// The progress of the trainingweek as a double fraction
    public var progress: Double {
        let allsession = self.allTrainingSessions
        let completedSession = allsession.filter({ $0.isComplete })
        let numberOfSessions = Double(allsession.count)
        let numberOfCompletedSessions = Double(completedSession.count)
        if numberOfSessions == 0 { return 0 }
        else { return (numberOfCompletedSessions / numberOfSessions) }
    }
    
    // Protocol implementation
    public func getNextPositionIndex() -> Int64 {
        let sessions: [TrainingSession] = self.trainingSessions?.allObjects as! [TrainingSession]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implmentation
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
    
    // Protocol implementation
    internal func getPositionIndexes() -> [Int64] {
        let children = self.trainingSessions!.allObjects as! [TrainingSession]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // Protocol implementation
    internal func hasCompleteableChildren() -> Bool {
        return !self.trainingSessions!.allObjects.isEmpty
    }
    
    // MARK: Validation
    
    // No extra validation on this class extension

}
