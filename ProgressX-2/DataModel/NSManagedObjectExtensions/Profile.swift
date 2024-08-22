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
    
    /// Gets the last completed session.
    public var lastSessionDone: TrainingSession? {
        let context = self.managedObjectContext!
        return CoreDataAccess.getLastSessionDone(context)
    }
    
    /// Gets the routine which contained the last completed session.
    public var lastRoutineUsed: Routine? {
        let context = self.managedObjectContext!
        return CoreDataAccess.getLastRoutineUsed(context)
    }
    
    /// Gets the latest bodyEntry.
    public var lastWeighIn: BodyEntry? {
        let context = self.managedObjectContext!
        return CoreDataAccess.getLatestBodyEntry(context)
    }
    
    /// Gets all sessions completed within this week.
    public var sessionsDoneThisWeek: [TrainingSession] {
        let context = self.managedObjectContext!
        return CoreDataAccess.getAllSessionsDoneThisWeek(context)
    }
    
    /// Gets all sessions completed within the last 30 days.
    public var sessionsDoneLast30Days: [TrainingSession] {
        let context = self.managedObjectContext!
        return CoreDataAccess.getAllSessionsDoneLast30days(context)
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
        let context = self.managedObjectContext!
        let duplicates = CoreDataAccess.profileNameIsUnique(context)
        if duplicates { throw ValidationNSErrors.profileNameIsInvalid.toNSError() }
    }
    
}
