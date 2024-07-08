//
//  CreateNewProfile1ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewProfile1ViewModel: ObservableObject {
    
    @Published var navPath: [Int] = [Int]()
    @Published var userName: String = ""
    @Published var birthDay: Date = Date()
    @Published var selectedUnitSegment: String = "Metric (meters)"
    @Published var selectedGenderSegment: String = "Male"
    @Published var weight: String = ""
    @Published var height: String = ""
    let unitSegments: [String] = ["Metric (meters)", "Imperial (feet)"]
    let genderSegments = ["Male", "Female"]
    @Published var userNameIsInvalid = false
    @Published var heightIsInvalid = false
    @Published var weightIsInvalid = false
    @Published var userNameIsInvalidMsg = ""
    @Published var heightIsInvalidMsg = ""
    @Published var weightIsInvalidMsg = ""
    
    var lengthUnit: String {
        (self.selectedUnitSegment == "Metric (meters)") ? "cm" : "ft"
    }
    
    var weightUnit: String {
        (self.selectedUnitSegment == "Metric (meters)") ? "kg" : "lbs"
    }
    
    public func createProfile(viewContext: NSManagedObjectContext, profiles: FetchedResults<Profile>) -> Void {
        if PersistenceController.profileExists(viewContext) {
            let profile = profiles.first!
            PersistenceController.delete(viewContext, object: profile)
            PersistenceController.save(viewContext)
        }
        
        // Transform input values into values that can be used in the datamodel.
        let isMetric = (selectedUnitSegment == "Metric (meters)") ? true : false
        let gender = (selectedGenderSegment == "Male") ? "male" : "female"
        let inputWeight = Double(weight)!
        let inputHeight = Double(height)!
        
        // Create Profile
        let profile = Profile(context: viewContext)
        profile.birthDay = birthDay
        profile.profileUserName = userName
        profile.height = inputHeight
        profile.gender = gender
        profile.isMetric = isMetric
        
        // Create BodyEntry
        let bodyWeightEntry = PersistenceController.createBodyEntry(
            viewContext,
            profile: profile,
            weight: inputWeight,
            date: Date()
        )
        
        // Add BodyEntry to the profile
        profile.addToBodyEntries(bodyWeightEntry)
        
        // Create basic exercies if they dont exist
        if !PersistenceController.basicExercisesExist(viewContext) {
            PersistenceController.generateBasicExerciseLibrary(viewContext)
        }
        
        PersistenceController.save(viewContext)
    }
    
}
