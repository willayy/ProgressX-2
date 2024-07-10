//
//  BodyEntry.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import Foundation
import CoreData

extension BodyEntry {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        profile: Profile,
        bodyWeight: Double,
        date: Date,
        chestCircumference: NSNumber? = nil,
        waistCirucmference: NSNumber? = nil,
        upperArmCircumference: NSNumber? = nil,
        lowerArmCircumference: NSNumber? = nil,
        thighCircumference: NSNumber? = nil,
        calfCircumference: NSNumber? = nil
    ) {
        self.init(context: context)
        self.profile = profile
        self.bodyWeight = bodyWeight
        self.achievedOnDate = date
        self.chestCirc = chestCircumference
        self.waistCirc = waistCirucmference
        self.uprArmCirc = upperArmCircumference
        self.lwrArmCirc = lowerArmCircumference
        self.thighCirc = thighCircumference
        self.calfCirc = calfCircumference
    }
    
    //MARK: Extra properties
    
    // Computed property for bodyWeightString formatted nicely
    var bodyWeightString: String {
        let weightUnit = PersistenceController.getWeightUnit(self.managedObjectContext!)!
        return String(format: "%.2f", self.bodyWeight) + weightUnit
    }
        
    //MARK: Validation
    
    // Nothing here
}
