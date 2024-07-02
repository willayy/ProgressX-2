//
//  Profile.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-27.
//

import Foundation
import CoreData

extension Profile {
    
    // MARK: Extra Properties
    
    // Nothing here
    
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
