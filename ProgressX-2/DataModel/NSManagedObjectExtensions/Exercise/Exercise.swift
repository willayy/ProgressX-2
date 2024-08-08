//
//  Exercise.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-27.
//

import Foundation
import CoreData

extension Exercise {
    
    // MARK: Convenience initializer
    
    convenience init(
        _ context: NSManagedObjectContext,
        name: String,
        description: String,
        type: String
    ) {
        self.init(context: context)
        self.exerciseName = name
        self.exerciseDesc = description
        self.exerciseType = type
    }
    
    // MARK: Extra Properties
    
    // Returns the string names of all exercise categories
    public var categoryString: String {
        let categories: [ExerciseCategory] = self.categories!.allObjects as! [ExerciseCategory]
        let categoryStrings: [String] = categories.map { $0.categoryName! }
        var categoryString: String = ""
        for category in categoryStrings {
            categoryString += category
            if !(categoryStrings.last == category) {
                categoryString += ", "
            }
        }
        
        return categoryString.isEmpty ? "No categories" : categoryString
    }
    
    public var latestPr: PersonalRecord? {
        let personalRecords = (self.personalRecords!.allObjects as! [PersonalRecord])
            .sorted(by: {$0.achievedOnDate! > $1.achievedOnDate!})
        return personalRecords.first
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateExerciseName()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForInsert()
        try validateExerciseName()
    }
    
    // Checks that no Exercises has the same name
    private func validateExerciseName() throws {
        let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
        var results = PersistenceController.fetch(self.managedObjectContext!, fetchRequest: fetchRequest)
        // Removing the self instance, this might be unnecessary
        results.removeAll { $0 === self }
        let duplicates = results.filter { $0.exerciseName! == self.exerciseName }
        if !duplicates.isEmpty { throw ValidationNSErrors.exerciseNameIsInvalid.toNSError() }
    }
    
}
