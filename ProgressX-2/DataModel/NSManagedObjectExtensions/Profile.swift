//
//  Profile.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-27.
//

import Foundation
import CoreData

extension Profile {
    
    // MARK: Convenienve init
    
    convenience init(
        _ context: NSManagedObjectContext,
        userName: String,
        gender: String,
        height: Double,
        isMetric: Bool,
        standardRestTime: Double = 180,
        smallestPlate: Double,
        birthDay: Date
    ) {
        self.init(context: context)
        self.profileUserName = userName
        self.gender = gender
        self.userHeight = height
        self.isMetric = isMetric
        self.standardRestTime = standardRestTime
        self.birthDay = birthDay
        self.smallestPlate = smallestPlate
    }
    
    // MARK: Extra Properties
    
    /// Gets all trainingSessions in the for the whole profile, returns empty array if none.
    private var allTrainingSessions: [TrainingSession] {
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all sessions completed within 30 days of today for all routines, returns empty array if none.
    public var sessionsCompletedLast30days: [TrainingSession] {
        let allSessions: [TrainingSession] = self.allTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        let sessionsCompletedWithin30Days = completedSessions.filter {
            $0.completedOnDate! >= thirtyDaysAgo && $0.completedOnDate! <= today
        }
        return sessionsCompletedWithin30Days
    }
    
    /// Gets all sessions completed within 7 days of today for all routines, returns empty array if none.
    public var sessionsCompletedThisWeek: [TrainingSession] {
        let allSessions: [TrainingSession] = self.allTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
        let sessionCompletedThisWeek = completedSessions.filter {
            $0.completedOnDate! > startOfWeek && $0.completedOnDate! <= endOfWeek!
        }
        return sessionCompletedThisWeek
    }
    
    /// Gets the last completed session for any routine done.
    public var lastCompletedSession: TrainingSession? {
        let allSessions: [TrainingSession] = self.allTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let orderedSessions = completedSessions.sorted(by: {$0.completedOnDate! > $1.completedOnDate!})
        return orderedSessions.first
    }
    
    /// Gets the routine of the last completed session.
    public var lastRoutineUsed: Routine? {
        guard let lastCompletedSession: TrainingSession = self.lastCompletedSession else { return nil }
        let week: TrainingWeek = lastCompletedSession.trainingWeek!
        let cycle: TrainingCycle = week.trainingCycle!
        let routine: Routine = cycle.routine!
        return routine
    }
    
    public var lastWeighIn: BodyEntry? {
        let bodyEntries: [BodyEntry] = self.bodyEntries!.allObjects as! [BodyEntry]
        let orderedBodyEntries = bodyEntries.sorted(by: {$0.achievedOnDate! > $1.achievedOnDate!})
        return orderedBodyEntries.first
    }
    
    public var standardRestTimeString: String {
        return String(format: "%.2f", self.standardRestTime)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateProfileName()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForInsert()
        try validateProfileName()
    }
    
    // Checks that Profile name is unique
    private func validateProfileName() throws {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        var results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        // Removing the self instance, this might be unnecessary
        results.removeAll { $0 === self }
        let duplicates = results.filter { $0.profileUserName! == self.profileUserName }
        if !duplicates.isEmpty { throw ValidationNSErrors.exerciseNameIsInvalid.toNSError() }
    }
    
}
