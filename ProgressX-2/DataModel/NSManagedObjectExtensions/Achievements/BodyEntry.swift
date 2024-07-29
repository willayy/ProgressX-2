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
        profile.addToBodyEntries(self)
    }
    
    //MARK: Extra properties
        
    private var lengthUnit: String? {
        guard let context = self.managedObjectContext else { return nil }
        guard let lengthUnit = PersistenceController.getLengthUnit(context) else { return nil }
        return lengthUnit
    }
    
    private var weightUnit: String? {
        guard let context = self.managedObjectContext else { return nil }
        guard let weightUnit = PersistenceController.getWeightUnit(context) else { return nil }
        return weightUnit
    }
    
    /// Computed property for the bodyWeight property formatted nicely as a string with weight unit. Returns nil if context or weight unit is not set.
    public var bodyWeightString: String? {
        guard let weightUnit = self.weightUnit else { return nil }
        let bodyWeight = String(format: "%.2f", self.bodyWeight)
        return "\(bodyWeight) \(weightUnit)"
    }
    
    /// Computed property for the chestCirc property formatted nicely as a string with length unit. Returns nil if context or length unit is not set.
    public var chestCircumferenceString: String? {
        guard let lengthUnit = self.lengthUnit else { return nil }
        let chestCirc = (self.chestCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.chestCirc!)) \(lengthUnit)"
        return "\(chestCirc)"
    }
    
    /// Computed property for the uprArmCirc property formatted nicely as a string with length unit. Returns nil if context or length unit is not set.
    public var upperArmCircumferenceString: String? {
        guard let lengthUnit = self.lengthUnit else { return nil }
        let uprArmCirc = (self.uprArmCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.uprArmCirc!)) \(lengthUnit)"
        return "\(uprArmCirc)"
    }
    
    /// Computed property for the lwrArmCirc property formatted nicely as a string with length unit. Returns nil if context or length unit is not set.
    public var lowerArmCircumferenceString: String? {
        guard let lengthUnit = self.lengthUnit else { return nil }
        let lwrArmCirc = (self.lwrArmCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.lwrArmCirc!)) \(lengthUnit)"
        return "\(lwrArmCirc)"
    }
    
    /// Computed property for the waistCirc property formatted nicely as a string with length unit. Returns nil if context or length unit is not set.
    public var waistCircumferenceString: String? {
        guard let lengthUnit = self.lengthUnit else { return nil }
        let waistCirc = (self.waistCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.waistCirc!)) \(lengthUnit)"
        return "\(waistCirc)"
    }
    
    /// Computed property for the thighCirc property formatted nicely as a string with length unit.  Returns nil if context or length unit is not set.
    public var thighCircumferenceString: String? {
        guard let lengthUnit = self.lengthUnit else { return nil }
        let thighCirc = (self.thighCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.thighCirc!)) \(lengthUnit)"
        return "\(thighCirc)"
    }
    
    /// Computed property for the calfCirc property formatted nicely as a string with length unit.  Returns nil if context or length unit is not set.
    public var calfCircumferenceString: String? {
        guard let lengthUnit = self.lengthUnit else { return nil }
        let calfCirc = (self.calfCirc == nil) ? "Not available" : "\(String(format: "%.2f", self.calfCirc!)) \(lengthUnit)"
        return "\(calfCirc)"
    }
    
    //MARK: Validation
    
    // Nothing here
}
