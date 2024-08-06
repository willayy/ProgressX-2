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
    
    func getNextPositionIndex() -> Int64 {
        let weeks: [TrainingWeek] = self.trainingWeeks?.allObjects as! [TrainingWeek]
        let max = weeks.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    public func getNextWeek() -> TrainingWeek? {
        let allWeeks = self.trainingWeeks!.allObjects as! [TrainingWeek]
        let orderedIncompleteWeeks: [TrainingWeek] = allWeeks.filter { week in !week.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteWeeks.first
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
        let weeks: [TrainingWeek] = self.trainingWeeks?.allObjects as! [TrainingWeek]
        let groupedBy = Dictionary(grouping: weeks, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    internal func childrenAreComplete() -> Bool {
        self.trainingWeeks!.allSatisfy { trainingWeeks in
            (trainingWeeks as! TrainingWeek).isComplete
        }
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error.
        if self.isComplete && self.trainingWeeks!.allObjects.isEmpty {
            throw ValidationNSErrors.cycleCompleteWithNoWeeks.toNSError()
        }
        
        // If Cycle is complete but it's weeks arent throw an error.
        if self.isComplete && !self.childrenAreComplete() {
            throw ValidationNSErrors.cycleCompleteWithUncompleteWeeks.toNSError()
        }
        
        // If cycle is incomplete but its week are throw an error.
        if !self.isComplete && self.childrenAreComplete() {
            throw ValidationNSErrors.cycleInCompleteWithCompleteWeeks.toNSError()
        }
        
    }
    
}
