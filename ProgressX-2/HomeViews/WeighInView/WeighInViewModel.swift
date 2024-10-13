//
//  WeighInViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-17.
//

import Foundation
import CoreData
import SwiftUI

class WeighInViewModel: ViewModel {
    
    // Input variables
    @Published public var bodyWeight: String = ""
    @Published public var chestCirc: String = ""
    @Published public var waistCirc: String = ""
    @Published public var upperArmCirc: String = ""
    @Published public var lowerArmCirc: String = ""
    @Published public var thighCirc: String = ""
    @Published public var calfCirc: String = ""
    
    /// Saves a new weigh in
    public func saveNewWeighIn(context: NSManagedObjectContext) -> Void {
        
        // Get the profile.
        let fetchRequest: NSFetchRequest<Profile> = Profile.fetchRequest()
        let results: [Profile] = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
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
            context,
            profile: profile,
            bodyWeight: Double(bodyWeight)!,
            date: Date(), chestCircumference: chestCirc,
            waistCirucmference: waistCirc,
            upperArmCircumference: upperArmCirc,
            lowerArmCircumference: lowerArmCirc,
            thighCircumference: thighCirc,
            calfCircumference: calfCirc
        )
        
        self.save(context)
        
    }
}
