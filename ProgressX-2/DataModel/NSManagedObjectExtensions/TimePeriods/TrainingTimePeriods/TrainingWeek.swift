//
//  Week.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation
import CoreData

extension TrainingWeek: HasOrderable, HasCompleteable, HasParent, HasChildren {
    
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
    
    // MARK: Protocol implementation
        
    typealias ParentType = TrainingCycle
    
    typealias ChildrenType = TrainingSession
    
    // Protocol implementation
    var children: [TrainingSession] {
        return self.trainingSessions!.allObjects as! [TrainingSession]
    }
    
    // Protocol implementation
    var parent: TrainingCycle {
        return self.trainingCycle!
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
    
    // MARK: Extra Properties
    
    /// The next trainingSession in the order of this TrainingWeek
    public var nextTrainingSession: TrainingSession? {
        let allSessions = self.trainingSessions!.allObjects as! [TrainingSession]
        let orderedIncompleteSessions: [TrainingSession] = allSessions
            .filter { session in !session.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteSessions.first
    }
    
    public var progress: Double {
        let context = self.managedObjectContext!
        return CoreDataAccess.getProgressOf(trainingWeek: self, context)
    }
    
    // MARK: Validation
    
    // No extra validation on this class extension

}
