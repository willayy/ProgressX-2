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
    
    /// Computed property for the bodyWeight property formatted nicely as a string with weight unit.
    public var bodyWeightString: String {
        let weightUnit = PersistenceController.getWeightUnit(self.managedObjectContext!)!
        let bodyWeight = String(format: "%.2f", self.bodyWeight)
        return "\(bodyWeight) \(weightUnit)"
    }
    
    /// Computed property for the chestCirc property formatted nicely as a string with length unit.
    public var chestCircumferenceString: String {
        let lengthUnit = PersistenceController.getLengthUnit(self.managedObjectContext!)!
        let chestCirc = (self.chestCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.chestCirc!)) \(lengthUnit)"
        return "\(chestCirc)"
    }
    
    /// Computed property for the uprArmCirc property formatted nicely as a string with length unit.
    public var upperArmCircumferenceString: String {
        let lengthUnit = PersistenceController.getLengthUnit(self.managedObjectContext!)!
        let uprArmCirc = (self.uprArmCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.uprArmCirc!)) \(lengthUnit)"
        return "\(uprArmCirc)"
    }
    
    /// Computed property for the lwrArmCirc property formatted nicely as a string with length unit.
    public var lowerArmCircumferenceString: String {
        let lengthUnit = PersistenceController.getLengthUnit(self.managedObjectContext!)!
        let lwrArmCirc = (self.lwrArmCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.lwrArmCirc!)) \(lengthUnit)"
        return "\(lwrArmCirc)"
    }
    
    /// Computed property for the waistCirc property formatted nicely as a string with length unit.
    public var waistCircumferenceString: String {
        let lengthUnit = PersistenceController.getLengthUnit(self.managedObjectContext!)!
        let waistCirc = (self.waistCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.waistCirc!)) \(lengthUnit)"
        return "\(waistCirc)"
    }
    
    /// Computed property for the thighCirc property formatted nicely as a string with length unit.
    public var thighCircumferenceString: String {
        let lengthUnit = PersistenceController.getLengthUnit(self.managedObjectContext!)!
        let thighCirc = (self.thighCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.thighCirc!)) \(lengthUnit)"
        return "\(thighCirc)"
    }
    
    /// Computed property for the calfCirc property formatted nicely as a string with length unit.
    public var calfCircumferenceString: String {
        let lengthUnit = PersistenceController.getLengthUnit(self.managedObjectContext!)!
        let calfCirc = (self.calfCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.calfCirc!)) \(lengthUnit)"
        return "\(calfCirc)"
    }
    
    //MARK: Validation
    
    // Nothing here
}
