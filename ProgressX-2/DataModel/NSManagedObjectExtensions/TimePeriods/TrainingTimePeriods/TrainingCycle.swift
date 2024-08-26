//
//  Cycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-18.
//

import Foundation
import CoreData

extension TrainingCycle: HasOrderable, HasCompleteable, HasParent {
    
    // MARK: Convenience init
    
    public convenience init(
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
    
    // MARK: Protocol implementation
        
    internal typealias ParentType = Routine
    
    internal typealias ChildrenType = TrainingWeek
    
    // Protocol implementation
    internal var children: [TrainingWeek] {
        return self.trainingWeeks!.allObjects as! [TrainingWeek]
    }
    
    // Protocol implementation
    internal var parent: Routine {
        return self.routine!
    }
    
    // Protocol implementation
    internal func getNextPositionIndex() -> Int64 {
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
    
    // MARK: Extra properties
    
    public var nextTrainingWeek: TrainingWeek? {
        let allWeeks = self.trainingWeeks!.allObjects as! [TrainingWeek]
        let orderedIncompleteWeeks: [TrainingWeek] = allWeeks
            .filter { week in !week.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteWeeks.first
    }
    
    public var progress: Double {
        let context = self.managedObjectContext!
        return CoreDataAccess.getProgressOf(trainingCycle: self, context)
    }
    
    // MARK: Validation
    
    // No extra validation on this class extension
    
}
