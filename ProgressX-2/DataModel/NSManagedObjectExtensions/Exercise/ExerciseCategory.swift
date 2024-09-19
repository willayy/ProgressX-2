//
//  ExerciseCategory.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-10.
//

import Foundation
import CoreData

extension ExerciseCategory {
    
    // MARK: Convenience init
    
    /// This initializer sets up a ExerciseCategory NSManagedObject correctly by assigning all the necessary attributes.
    convenience init(
        _ context: NSManagedObjectContext,
        name: String
    ) {
        self.init(context: context)
        self.categoryName = name
    }
    
    // MARK: Extra properties
    
    // Nothing here
    
    // MARK: Validation
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateCategoryNameIsUnique()
    }
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
        try validateCategoryNameIsUnique()
    }
    
    /// Validates that the name of the category is unique.
    private func validateCategoryNameIsUnique() throws {
        
        let context = self.managedObjectContext!
        
        let duplicatesDoesNotExist = CoreDataAccess.categoryNameIsUnique(context)
        
        if !duplicatesDoesNotExist {
            
            throw ValidationNSErrors.exerciseCategoryNameIsInvalid.toNSError()
            
        }
    }
    
}
