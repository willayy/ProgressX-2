//
//  Routine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import Foundation
import CoreData

extension Routine: HasOrderable, HasChildren {
    
    // MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        name: String,
        description: String
    ) {
        self.init(context: context)
        self.timePeriodName = name
        self.timePeriodDescription = description
        self.createdOnDate = Date()
    }
    
    /// Initializer for a Routine using JSON data
    convenience init(
        _ context: NSManagedObjectContext,
        json: [String : Any]
    ) {
        self.init(context: context)
        self.timePeriodName = (json["timePeriodName"] as! String)
        self.timePeriodDescription = (json["timePeriodDescription"] as! String)
        self.createdOnDate = Date()
    }
    
    // MARK: Extra properties
    
    /// The last completed session of this routine.
    public var lastSessionDone: TrainingSession? {
        let context = self.managedObjectContext!
        return CoreDataAccess.getLastSessionDoneIn(routine: self, context)
    }
    
    /// The sessions completed within the last 30 days.
    public var sessionsDoneLast30Days: [TrainingSession] {
        let context = self.managedObjectContext!
        return CoreDataAccess.getSessionsDoneLast30DaysIn(routine: self, context)
    }
    
    /// The sessions completed within the last 7 days.
    public var sessionsDoneLast7Days: [TrainingSession] {
        let context = self.managedObjectContext!
        return CoreDataAccess.getSessionsDoneLast7DaysIn(routine: self, context)
    }
    
    /// The exercises used in this routine.
    public var exercises: [String : Int] {
        let context = self.managedObjectContext!
        return CoreDataAccess.getAllExercisesIn(routine: self, context)
    }
    
    /// All categories on exercises used in this routine.
    public var categories: [String : Int] {
        let context = self.managedObjectContext!
        return CoreDataAccess.getCategoriesIn(routine: self, context)
    }
    
    /// Gets the date when the routine was created presented as a string.
    public var formattedCreatedOnDate: String? {
        if self.createdOnDate == nil { return nil }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self.createdOnDate!)
    }
    
    /// Gets all completed cycles of thre routine, returns empty array if none. Returns nil if context is not set.
    public var completedCycles: [TrainingCycle]? {
        let allTrainingCycles = self.trainingCycles!.allObjects as! [TrainingCycle]
        let completedTrainingCycles = allTrainingCycles.filter({$0.isComplete})
        return completedTrainingCycles
    }
    
    /// Checks if there is an active training cycle in the routine
    public var incompleteTrainingCycleExists: Bool {
        if self.trainingCycles!.allObjects.isEmpty {
            return false
        } else {
          return !self.trainingCycles!.allSatisfy {
              trainingCycle in
                (trainingCycle as! TrainingCycle).isComplete
            }
        }
    }
    
    /// Gets the next uncomplete training cycle.
    public var nextTrainingCycle: TrainingCycle? {
        let allCycles = self.trainingCycles!.allObjects as! [TrainingCycle]
        let orderedIncompleteCycles: [TrainingCycle] = allCycles
            .filter { cycle in !cycle.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteCycles.first
    }
    
    // MARK: Protocol implementation
    
    // Protocol implementation
    public func getNextPositionIndex() -> Int64 {
        let cycles: [TrainingCycle] = self.trainingCycles?.allObjects as! [TrainingCycle]
        let max = cycles.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    func getPositionIndexes() -> [Int64] {
        let children = self.trainingCycles!.allObjects as! [TrainingCycle]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // Protocol implementation
    typealias ChildrenType = TrainingCycle
    
    // Protocol implementation
    public var children: [TrainingCycle] {
        return self.trainingCycles!.allObjects as! [TrainingCycle]
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateRoutineName()
        try validateTrainingCycles()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateRoutineName()
        try validateTrainingCycles()
    }
    
    /// Validates that the routine name is unique
    private func validateRoutineName() throws {
        let context = self.managedObjectContext!
        let duplicates = CoreDataAccess.routineNameIsUnique(context)
        if duplicates {
            throw ValidationNSErrors.routineNameIsInvalid.toNSError()
        }
    }
    
    /// Validates that the Routine always has one and one only started Cycles
    private func validateTrainingCycles() throws {
        let trainingCycles = self.trainingCycles!.allObjects as! [TrainingCycle]
        let incompleteTrainingCycles = trainingCycles.filter({ !$0.isComplete })
        if incompleteTrainingCycles.count != 1 {
            throw ValidationNSErrors.routineHasInvalidAmountOfIncompleteCycles.toNSError()
        }
    }
        
}
