//
//  CreateNewProfile1ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewProfile1ViewModel: SavingViewModel {
    
    // Navpath variable
    @Published public var navPath: [Int] = [Int]()
    
    // Input variables
    @Published public var birthDay: Date = Date()
    @Published public var userName: String = ""
    @Published public var weight: String = ""
    @Published public var height: String = ""
    
    // Input variables are invalid states
    @Published public var userNameIsInvalid = false
    @Published public var heightIsInvalid = false
    @Published public var weightIsInvalid = false
    
    // Input variables invalid messages
    @Published public var userNameIsInvalidMsg = ""
    @Published public var heightIsInvalidMsg = ""
    @Published public var weightIsInvalidMsg = ""
    
    // StringSelectionList selection
    @Published public var smallestPlateSelection: String = "1.25 kg's"
    
    // Seg picker selections
    @Published public var selectedUnitSegment: Bool = true
    @Published public var selectedGenderSegment: String = "male"
    
    // Seg picker options
    public let unitSegments: [String : Bool] = [
        "Metric" : true,
        "Imperial" : false
    ]
    
    public let genderSegments: [String : String] = [
        "Male" : "male",
        "Female" : "female"
    ]
    
    public override func lengthUnit(_ context: NSManagedObjectContext) -> String {
        (self.selectedUnitSegment) ? "cm" : "ft"
    }
    
    public override func weightUnit(_ context: NSManagedObjectContext) -> String {
        (self.selectedUnitSegment) ? "kg" : "lbs"
    }
    
    #warning("TODO: Make same change to StringSelectionList")
    public var smallestPlateSegments: [String] {
        if selectedUnitSegment {
            return [
                "1.25 kg's",
                "2.5 kg's",
                "5 kg's",
                "10 kg's"
            ]
        } else {
            return [
                "2.5 lbs",
                "5 lbs",
                "10 lbs"
            ]
        }
    }
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        // If the profile exists, delete the profile.
        if PersistenceController.profileExists(viewContext) {
            let profile = PersistenceController.getProfile(viewContext)
            PersistenceController.delete(viewContext, object: profile!)
            PersistenceController.save(viewContext)
        }
        
        // Transform input values into values that can be used in the datamodel.
        let smallestPlate = {
            let numericalValue: String = self.smallestPlateSelection
                .replacingOccurrences(of: " kg's", with: "")
                .replacingOccurrences(of: " lbs", with: "")
            return Double(numericalValue)!
        }()
        
        // Create Profile
        let profile = Profile(
            viewContext,
            userName: userName,
            gender: selectedGenderSegment,
            height: Double(height)!,
            isMetric: selectedUnitSegment,
            smallestPlate: smallestPlate,
            birthDay: birthDay
        )
        
        // Create BodyEntry
        let _ = BodyEntry(
            viewContext,
            profile: profile,
            bodyWeight: Double(weight)!,
            date: Date()
        )
        
        // Create basic exercies if they dont exist
        if !PersistenceController.basicExercisesExist(viewContext) {
            PersistenceController.generateBasicExerciseCategories(viewContext)
            PersistenceController.generateBasicExerciseLibrary(viewContext)
        }
        
        self.safeSave(viewContext: viewContext)
    }
    
}
