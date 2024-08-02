//
//  WeighInViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import Foundation
import CoreData
import SwiftUI

class WeighInViewModel: SavingViewModel, AddingViewModel {
    
    // Input variables
    @Published public var bodyWeight: String = ""
    @Published public var chestCirc: String = ""
    @Published public var waistCirc: String = ""
    @Published public var upperArmCirc: String = ""
    @Published public var lowerArmCirc: String = ""
    @Published public var thighCirc: String = ""
    @Published public var calfCirc: String = ""
    
    // Input invalid variables
    @Published public var bodyWeightIsInvalid: Bool = false
    @Published public var chestCircIsInvalid: Bool = false
    @Published public var waistCircIsInvalid: Bool = false
    @Published public var upperArmCircIsInvalid: Bool = false
    @Published public var lowerArmIsInvalid: Bool = false
    @Published public var thighCircIsInvalid: Bool = false
    @Published public var calfCircIsInvalid: Bool = false

    // Error message variables
    @Published public var bodyWeightIsInvalidMsg: String = ""
    @Published public var chestCircIsInvalidMsg: String = ""
    @Published public var waistCircIsInvalidMsg: String = ""
    @Published public var upperArmCircIsInvalidMsg: String = ""
    @Published public var lowerArmIsInvalidMsg: String = ""
    @Published public var thighCircIsInvalidMsg: String = ""
    @Published public var calfCircIsInvalidMsg: String = ""
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        // Get the profile.
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let results: [Profile] = PersistenceController.fetch(viewContext, fetchRequest: fetchRequest)
        let profile: Profile = results.first!
        
        // Convert input strings to optional NSNumbers.
        let chestCirc: NSNumber? = (chestCirc.isEmpty) ? nil : NSNumber(value: Double(chestCirc)!)
        let waistCirc: NSNumber? = (waistCirc.isEmpty) ? nil : NSNumber(value: Double(waistCirc)!)
        let thighCirc: NSNumber? = (thighCirc.isEmpty) ? nil : NSNumber(value: Double(thighCirc)!)
        let calfCirc: NSNumber? = (calfCirc.isEmpty) ? nil : NSNumber(value: Double(calfCirc)!)
        let upperArmCirc: NSNumber? = (upperArmCirc.isEmpty) ? nil : NSNumber(value: Double(upperArmCirc)!)
        let lowerArmCirc: NSNumber? = (lowerArmCirc.isEmpty) ? nil : NSNumber(value: Double(lowerArmCirc)!)

        // Create the bodyEntry.
        let _ = BodyEntry(
            viewContext,
            profile: profile,
            bodyWeight: Double(bodyWeight)!,
            date: Date(), chestCircumference: chestCirc,
            waistCirucmference: waistCirc,
            upperArmCircumference: upperArmCirc,
            lowerArmCircumference: lowerArmCirc,
            thighCircumference: thighCirc,
            calfCircumference: calfCirc
        )
        
        self.safeSave(viewContext: viewContext)
        
    }
}
