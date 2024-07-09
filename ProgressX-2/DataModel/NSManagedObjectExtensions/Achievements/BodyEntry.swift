//
//  BodyEntry.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import Foundation

extension BodyEntry {
    
    //MARK: Extra properties
    
    // Computed property for bodyWeightString formatted nicely
    var bodyWeightString: String {
        let weightUnit = PersistenceController.getWeightUnit(self.managedObjectContext!)!
        return String(format: "%.2f", self.bodyWeight) + weightUnit
    }
        
    //MARK: Validation
    
    // Nothing here
}
