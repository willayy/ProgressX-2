//
//  Profile.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-27.
//

import Foundation
import CoreData

extension Profile {
    
    // MARK: Convenience init
    
    /// This initializer sets up a Profile NSManagedObject correctly by assigning all the necessary attributes.
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
    
    /// Gets all trainingSessions, completed or not, in the for the whole profile, returns empty array if there are none.
    private var getAllTrainingSessions: [TrainingSession] {
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        let results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        return results
    }
    
    /// Gets all sessions completed within 30 days of today for all routines, returns empty array if none.
    public var getSessionsCompletedLast30days: [TrainingSession] {
        let allSessions: [TrainingSession] = self.getAllTrainingSessions
        // Filter out all the incomplete sessions.
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let today = Date()
        let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: today)!
        // unsafely unwrapping .completedOnDate because sessions are filtered.
        let sessionsCompletedWithin30Days = completedSessions.filter {
            $0.completedOnDate! >= thirtyDaysAgo && $0.completedOnDate! <= today
        }
        return sessionsCompletedWithin30Days
    }
    
    /// Gets all sessions completed within 7 days of today for all routines, returns empty array if none.
    public var getSessionsCompletedThisWeek: [TrainingSession] {
        let allSessions: [TrainingSession] = self.getAllTrainingSessions
        // Filter out all the incomplete sessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        let calendar = Calendar.current
        let today = Date()
        let startOfWeek = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: today))!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)
        // unsafely unwrapping .completedOnDate because sessions are filtered.
        let sessionCompletedThisWeek = completedSessions.filter {
            $0.completedOnDate! > startOfWeek && $0.completedOnDate! <= endOfWeek!
        }
        return sessionCompletedThisWeek
    }
    
    /// Gets the last completed session for any routine done. Returns nil if no sessions are completed.
    public var getLastCompletedSession: TrainingSession? {
        let allSessions: [TrainingSession] = self.getAllTrainingSessions
        let completedSessions: [TrainingSession] = allSessions.filter { $0.isComplete }
        // Pick the session with the smallest completion date.
        let lastCompleteSession = completedSessions.min(by: { $0.completedOnDate! < $1.completedOnDate! })
        return lastCompleteSession
    }
    
    /// Gets the routine of the last completed session. Returns nil of no sessions are completed.
    public var getLastRoutineUsed: Routine? {
        // If no sessions has been completed return nil
        guard let lastCompletedSession: TrainingSession = self.getLastCompletedSession else { return nil }
        // Get the week, then the cycle, then the routine...
        let week: TrainingWeek = lastCompletedSession.trainingWeek!
        let cycle: TrainingCycle = week.trainingCycle!
        let routine: Routine = cycle.routine!
        return routine
    }
    
    /// Gets the latest bodyentry from the latest weight in.
    public var getLastWeighIn: BodyEntry? {
        let bodyEntries: [BodyEntry] = self.bodyEntries!.allObjects as! [BodyEntry]
        let lastBodyEntry = bodyEntries.min(by: { $0.achievedOnDate! < $1.achievedOnDate! })
        return lastBodyEntry
    }
    
    /// A formatted version of the standard rest time attribute
    public var formattedStandardRestTime: String {
        return String(format: "%.2f", self.standardRestTime)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateProfileNameIsUnique()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForInsert()
        try validateProfileNameIsUnique()
    }
    
    /// Validates that the profiles name is unique
    private func validateProfileNameIsUnique() throws {
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        var fetchResults = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        // Removing the self instance, this might be unnecessary
        fetchResults.removeAll { $0 === self }
        let duplicates = fetchResults.contains { $0.profileUserName! == self.profileUserName }
        if duplicates { throw ValidationNSErrors.profileNameIsInvalid.toNSError() }
    }
    
}
