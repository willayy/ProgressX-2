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
        return String(format: "%.2f", self.bodyWeight)
    }
        
    //MARK: Validation
    
    // Nothing here
}
