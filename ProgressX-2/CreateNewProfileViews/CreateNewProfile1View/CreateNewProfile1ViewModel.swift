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
    
    @Published var navPath: [Int] = [Int]()
    @Published var userName: String = ""
    @Published var birthDay: Date = Date()
    @Published var selectedUnitSegment: String = "Metric"
    @Published var selectedGenderSegment: String = "Male"
    @Published var weight: String = ""
    @Published var height: String = ""
    let unitSegments: [String] = ["Metric", "Imperial"]
    let genderSegments = ["Male", "Female"]
    @Published var userNameIsInvalid = false
    @Published var heightIsInvalid = false
    @Published var weightIsInvalid = false
    @Published var userNameIsInvalidMsg = ""
    @Published var heightIsInvalidMsg = ""
    @Published var weightIsInvalidMsg = ""
    @Published var smallestPlateSelection: String = "1.25 kg's"
    
    public var lengthUnit: String {
        (self.selectedUnitSegment == "Metric") ? "cm" : "ft"
    }
    
    public var weightUnit: String {
        (self.selectedUnitSegment == "Metric") ? "kg" : "lbs"
    }
    
    public var smallestPlateSegments: [String] {
        if selectedUnitSegment == "Metric" {
            return ["1.25 kg's", "2.5 kg's", "5 kg's", "10 kg's"]
        } else {
            return ["2.5 lbs", "5 lbs", "10 lbs"]
        }
    }
    
    public func createProfile(viewContext: NSManagedObjectContext, profiles: FetchedResults<Profile>) -> Void {
        if PersistenceController.profileExists(viewContext) {
            let profile = profiles.first!
            PersistenceController.delete(viewContext, object: profile)
            PersistenceController.save(viewContext)
        }
        
        // Transform input values into values that can be used in the datamodel.
        let isMetric = (selectedUnitSegment == "Metric") ? true : false
        let gender = (selectedGenderSegment == "Male") ? "male" : "female"
        let inputWeight = Double(weight)!
        let inputHeight = Double(height)!
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
            gender: gender,
            height: inputHeight,
            isMetric: isMetric,
            smallestPlate: smallestPlate,
            birthDay: birthDay
        )
        
        // Create BodyEntry
        let _ = BodyEntry(
            viewContext,
            profile: profile,
            bodyWeight: inputWeight,
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
