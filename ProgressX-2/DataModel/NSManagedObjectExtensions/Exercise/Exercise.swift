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
    
    /// This initializer sets up an Exercise NSManagedObject correctly by assigning all the necessary attributes.
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
    
    /// Returns a concatenated string with all the categories.
    public var formattedCategories: String? {
        let categories: [ExerciseCategory] = self.categories!.allObjects as! [ExerciseCategory]
        let categoryNames: [String] = categories.map { $0.categoryName! }
        var categoryString: String = ""
        
        for name in categoryNames {
            categoryString += name
            // If the name is the last one in the list of category names dont put a comma to separate
            if !(name == categoryNames.last) {
                categoryString += ", "
            }
        }
        
        return categoryString
    }
    
    /// Gets the latest PR achieved on this exercise
    public var latestPr: PersonalRecord? {
        let personalRecords = (self.personalRecords!.allObjects as! [PersonalRecord])
        let latestPr = personalRecords.min(by: {$0.achievedOnDate! < $1.achievedOnDate!})
        return latestPr
    }
    
    // MARK: Protocol implementation
    
    // No protocol implemenation in this class extension
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateExerciseNameIsUnique()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForInsert()
        try validateExerciseNameIsUnique()
    }
    
    /// Checks that the name of the exercise is unique
    private func validateExerciseNameIsUnique() throws {
        let context = self.managedObjectContext!
        let duplicates = CoreDataAccess.exerciseNameIsUnique(context)
        if duplicates {
            throw ValidationNSErrors.exerciseNameIsInvalid.toNSError()
        }
    }
    
}
