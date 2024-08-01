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
    }
    
    override public func validateForInsert() throws {
        try super.validateForInsert()
    }
    
    private func validateName() throws {
        let fetchRequest = ExerciseCategory.fetchRequest()
        var results = PersistenceController.fetch(
            self.managedObjectContext!,
            fetchRequest: fetchRequest
        )
        results.removeAll {$0 === self}
        let duplicates = results.filter { $0.categoryName! == self.categoryName }
        if !duplicates.isEmpty {
            throw ValidationNSErrors.exerciseCategoryNameIsInvalid.toNSError()
        }
    }
    
}
