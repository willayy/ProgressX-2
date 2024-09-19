//
//  Session.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation
import CoreData

extension TrainingSession: HasOrderable, HasCompleteable, HasParent, HasChildren {
    
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
    
    // MARK: Protocol implementation
        
    internal typealias ParentType = TrainingWeek
    
    internal typealias ChildrenType = TrainingSet
    
    // Protocol implementation
    internal var children: [TrainingSet] {
        return self.trainingSets!.allObjects as! [TrainingSet]
    }
    
    // Protocol implementation
    internal var parent: TrainingWeek {
        return self.trainingWeek!
    }
    
    // Protocol implementation
    internal func getNextPositionIndex() -> Int64 {
        let sets: [TrainingSet] = self.trainingSets?.allObjects as! [TrainingSet]
        let max = sets.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    internal func childrenAreComplete() -> Bool {
        if self.trainingSets!.allObjects.isEmpty {
            return false
        } else {
          return self.trainingSets!.allSatisfy {
              trainingSet in
                (trainingSet as! TrainingSet).isComplete
            }
        }
    }
    
    // Protocol implementation
    internal func getPositionIndexes() -> [Int64] {
        let children = self.trainingSets!.allObjects as! [TrainingSet]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // Protocol implementation
    internal func hasCompleteableChildren() -> Bool {
        return !self.trainingSets!.allObjects.isEmpty
    }
    
    // MARK: Extra Properties
    
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
            // Normalize dates by their start of day dates
            let startOfDayNow: Date = calendar.startOfDay(for: now)
            let completedSessionStartOfDay: Date = calendar.startOfDay(for: self.completedOnDate!)
            let components = calendar.dateComponents([.day], from: completedSessionStartOfDay, to: startOfDayNow)
            let daysAgo = components.day ?? 0
            return String(daysAgo)
        } else {
            return nil
        }
    }
    
    /// Gets the next trainingset of this session
    public var nextTrainingSet: TrainingSet? {
        let allSets = self.trainingSets!.allObjects as! [TrainingSet]
        let orderedIncompleteSets: [TrainingSet] = allSets
            .filter { set in !set.isComplete }
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        return orderedIncompleteSets.first
    }
    
    // MARK: Validation
    
    // No extra validation on this class extension
    
}
