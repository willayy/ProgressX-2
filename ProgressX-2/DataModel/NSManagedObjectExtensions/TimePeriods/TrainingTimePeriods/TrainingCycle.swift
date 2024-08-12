//
//  Cycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation
import CoreData

extension TrainingCycle: HasOrderable, HasCompleteable {
    
    // MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        routine: Routine,
        name: String = "",
        description: String = ""
    ) {
        self.init(context: context)
        self.routine = routine
        let routineName = routine.timePeriodName!
        let positionIndex = routine.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "\(routineName) cycle \(positionIndex)" : name
        self.timePeriodDescription = (description == "") ? "Cycle created for \(routineName)" : description
        self.templateCycle = routine.templateCycle
        self.startedOnDate = Date()
        routine.addToTrainingCycles(self)
    }
    
    // MARK: Extra properties
    
    public var nextTrainingWeek: TrainingWeek? {
        let allWeeks = self.trainingWeeks!.allObjects as! [TrainingWeek]
        let orderedIncompleteWeeks: [TrainingWeek] = allWeeks
            .filter { week in !week.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteWeeks.first
    }
    
    /// Gets all TrainingSessions in this cycle
    public var allTrainingSessions: [TrainingSession] {
        let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "trainingWeek.trainingCycle == %@", self)
        let context = self.managedObjectContext!
        let sessions = PersistenceController.fetch(context, fetchRequest: fetchRequest)
        return sessions
    }
    
    /// Gets the completion status of this cycle
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
        let weeks: [TrainingWeek] = self.trainingWeeks?.allObjects as! [TrainingWeek]
        let max = weeks.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    internal func childrenAreComplete() -> Bool {
        if self.trainingWeeks!.allObjects.isEmpty {
            return false
        } else {
          return self.trainingWeeks!.allSatisfy {
              trainingWeeks in
                (trainingWeeks as! TrainingWeek).isComplete
            }
        }
    }
    
    // Protocol implementation
    internal func getPositionIndexes() -> [Int64] {
        let children = self.trainingWeeks!.allObjects as! [TrainingWeek]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // Protocol implementation
    internal func hasCompleteableChildren() -> Bool {
        return !self.trainingWeeks!.allObjects.isEmpty
    }
    
    // MARK: Validation
    
    // No extra validation on this class extension
    
}
