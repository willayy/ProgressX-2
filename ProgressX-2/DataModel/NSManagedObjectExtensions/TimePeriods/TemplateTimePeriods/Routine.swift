//
//  Routine.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-20.
//

import Foundation
import CoreData

extension Routine: HasOrderable {
    
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
    
    // MARK: Extra properties
    
    /// Gets all trainingSessions in the routine, returns empty array if none.
    private var allTrainingSessions: [TrainingSession] {
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let predicate = NSPredicate(format: "trainingWeek.trainingCycle.routine == %@", self)
        fetchRequest.predicate = predicate
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all templateSets in the routine, returns empty array if none.
    private var allTemplateSets: [TemplateSet] {
        let fetchRequest: NSFetchRequest<TemplateSet> = TemplateSet.fetchRequest()
        let predicate = NSPredicate(format: "templateSession.templateWeek.templateCycle.routine == %@", self)
        fetchRequest.predicate = predicate
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all exercises of the routine.
    private var allExercises: [Exercise] {
        let allTemplateSets = self.allTemplateSets
        let allExercises = allTemplateSets.map { $0.exercise! }
        return allExercises
    }
    
    public var weeksInRoutine: [TemplateWeek] {
        return self.templateCycle!.templateWeeks!.allObjects as! [TemplateWeek]
    }
    
    /// Gets the last session done, returns nil if no sessions done.
    public var lastCompletedSession: TrainingSession? {
        let allSessions: [TrainingSession] = self.allTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let orderedSessions = completedSessions.sorted(by: {$0.completedOnDate! > $1.completedOnDate!})
        return orderedSessions.first
    }
    
    /// Gets all sessions completed within 30 days of today, returns empty array if none.
    public var sessionsDoneThisMonth: [TrainingSession] {
        let allSessions: [TrainingSession] = self.allTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        let sessionsCompletedWithin30Days = completedSessions.filter { $0.completedOnDate! >= thirtyDaysAgo && $0.completedOnDate! <= today }
        return sessionsCompletedWithin30Days
    }
    
    /// Gets all sessions completed within 7 days of today, returns empty array if none.
    public var sessionsDoneThisWeek: [TrainingSession] {
        let allSessions: [TrainingSession] = self.allTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: today)!
        let sessionsCompletedWithin7Days = completedSessions.filter { $0.completedOnDate! >= sevenDaysAgo && $0.completedOnDate! <= today }
        return sessionsCompletedWithin7Days
    }
    
    /// Gets the date when the routine was created presented as a string.
    public var creationDateString: String? {
        if self.createdOnDate == nil { return nil }
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df.string(from: self.createdOnDate!)
    }
    
    /// Gets all completed cycles of thre routine, returns empty array if none. Returns nil if context is not set.
    public var completedCycles: [TrainingCycle]? {
        guard let context = self.managedObjectContext else {return nil}
        let fetchRequest: NSFetchRequest<TrainingCycle> = TrainingCycle.fetchRequest()
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [
            NSPredicate(format: "routine == %@", self),
            NSPredicate(format: "isComplete == %@", NSNumber(value: true))
        ])
        let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all the exercises in the routine as a dictionary where the keys are the exercises and the values the frequency.
    public var exerciseInRoutine: [String : Int] {
        let allExercises = self.allExercises
        let exerciseDictionary = Dictionary(grouping: allExercises) { $0.exerciseName! }
            .mapValues { $0.count }
        return exerciseDictionary
    }
    
    /// Gets all the categories in the routine as a dictionary where the keys are the exercise-categories and the values the frequency.
    public var categoriesInRoutine: [String : Int] {
        let allExercises = self.allExercises
        let allCategories = allExercises.flatMap { $0.categories! }
        let categoryDictionary = Dictionary(grouping: (allCategories as! [ExerciseCategory])) { $0.categoryName! }
            .mapValues { $0.count }
        return categoryDictionary
    }
    
    /// Gets the next available
    /// - Returns: An Int64 that is a valid positionIndex
    public func getNextPositionIndex() -> Int64 {
        let cycles: [TrainingCycle] = self.trainingCycles?.allObjects as! [TrainingCycle]
        let max = cycles.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    /// Checks if there is an active training cycle in the routine
    public func activeTrainingCycleExists() -> Bool {
        if self.trainingCycles!.allObjects.isEmpty {
            return false
        } else {
          return self.trainingCycles!.allSatisfy {
              trainingCycle in
                (trainingCycle as! TrainingCycle).isComplete
            }
        }
    }
    
    public func getNextWeek() -> TrainingWeek? {
        let nextCycle = self.getNextTrainingCycle()
        let nextWeek = nextCycle?.getNextTrainingWeek()
        return nextWeek
    }
    
    public func getNextSession() -> TrainingSession? {
        let nextCycle = self.getNextTrainingCycle()
        let nextWeek = nextCycle?.getNextTrainingWeek()
        let nextSession = nextWeek?.getNextTrainingSession()
        return nextSession
    }
    
    /// Gets the next training cycle
    public func getNextTrainingCycle() -> TrainingCycle? {
        let allCycles = self.trainingCycles!.allObjects as! [TrainingCycle]
        let orderedIncompleteCycles: [TrainingCycle] = allCycles
            .filter { cycle in !cycle.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteCycles.first
    }
    
    // MARK: Validation
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateRoutineName()
        try validatePositionIndexes()
    }
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateRoutineName()
        try validatePositionIndexes()
    }
    
    // Checks that the routine name is unique
    private func validateRoutineName() throws {
        let context = self.managedObjectContext!
        let fetchrequest: NSFetchRequest<Routine> = Routine.fetchRequest()
        var results: [Routine] = PersistenceController.fetch(context, fetchRequest: fetchrequest)
        results.removeAll { $0 === self } // remove self
        if results.contains(where: {$0.timePeriodName == self.timePeriodName }) {
            throw ValidationNSErrors.routineNameIsInvalid.toNSError()
        }
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let cycles: [TrainingCycle] = self.trainingCycles?.allObjects as! [TrainingCycle]
        let groupedBy = Dictionary(grouping: cycles, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty {
            throw ValidationNSErrors.positionIndexIsInvalid.toNSError()
        }
    }
    
    // Validates that the Routine always has one and one only started Cycles
    private func validateTrainingCycles() throws {
        
        let trainingCycles = self.trainingCycles!.allObjects as! [TrainingCycle]
        
        let incompleteTrainingCycles = trainingCycles.filter({ !$0.isComplete })
        
        if incompleteTrainingCycles.count != 1 {
            throw ValidationNSErrors.routineHasInvalidAmountOfIncompleteCycles.toNSError()
        }
    }
        
}
