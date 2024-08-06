//
//  Session.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension TrainingSession: HasOrderable, HasCompleteable {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        trainingWeek: TrainingWeek,
        templateSession: TemplateSession
    ) {
        self.init(context: context)
        self.trainingWeek = trainingWeek
        self.templateSession = templateSession
        let positionIndex = trainingWeek.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = templateSession.timePeriodName
        self.timePeriodDescription = templateSession.timePeriodDescription
        self.startedOnDate = Date()
        trainingWeek.addToTrainingSessions(self)
    }
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sets: [TrainingSet] = self.trainingSets?.allObjects as! [TrainingSet]
        let max = sets.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    /// Gets the completion date of a trainingSession as a weekday string (Mon,Tue,Wed,...,Sun)
    public var completedOnDayString: String? {
        if self.isComplete {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEE"
            return dateFormatter.string(from: self.completedOnDate!)
        } else {
            return nil
        }
    }
    
    /// Gets how many days ago a trainingSession was completed as a string "0", "1" etc...
    public var completedDaysAgo: String? {
        if self.isComplete {
            let calendar = Calendar.current
            let now = Date()
            let components = calendar.dateComponents([.day], from: self.completedOnDate! , to: now)
            let daysAgo = components.day ?? 0
            return String(daysAgo)
        } else {
            return nil
        }
    }
    
    public func getNextSet() -> TrainingSet? {
        let allSets = self.trainingSets!.allObjects as! [TrainingSet]
        let orderedIncompleteSets: [TrainingSet] = allSets.filter { set in !set.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteSets.first
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
        self.trainingSets!.allSatisfy { trainingSet in
            (trainingSet as! TrainingSet).isComplete
        }
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let sets: [TrainingSet] = self.trainingSets?.allObjects as! [TrainingSet]
        let groupedBy = Dictionary(grouping: sets, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
    
    private func validateIsComplete() throws {
        // if session is complete and its relationship sets is empty throw an error
        if self.isComplete && self.trainingSets!.allObjects.isEmpty {
            throw ValidationNSErrors.sessionCompleteWithNoSets.toNSError()
        }
        
        // If session is complete but it's sets arent throw an error
        if self.isComplete && !self.childrenAreComplete() {
            throw ValidationNSErrors.sessionCompleteWithUncompleteSets.toNSError()
        }
        
        // If session is incomplete but its sets are completed
        if !self.isComplete && self.childrenAreComplete() {
            throw ValidationNSErrors.sessionIncompleteWithCompleteSets.toNSError()
        }
    }
}
