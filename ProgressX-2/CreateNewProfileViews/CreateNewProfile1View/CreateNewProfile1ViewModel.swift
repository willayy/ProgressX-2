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
    
    @Published public var navPath: [Int] = [Int]()
    @Published public var userName: String = ""
    @Published public var birthDay: Date = Date()
    @Published public var selectedUnitSegment: String = "Metric"
    @Published public var selectedGenderSegment: String = "Male"
    @Published public var weight: String = ""
    @Published public var height: String = ""
    @Published public var userNameIsInvalid = false
    @Published public var heightIsInvalid = false
    @Published public var weightIsInvalid = false
    @Published public var userNameIsInvalidMsg = ""
    @Published public var heightIsInvalidMsg = ""
    @Published public var weightIsInvalidMsg = ""
    @Published public var smallestPlateSelection: String = "1.25 kg's"
    @Published public var profile: Profile? = nil
    public let unitSegments: [String] = ["Metric", "Imperial"]
    public let genderSegments = ["Male", "Female"]
    
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
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        if PersistenceController.profileExists(viewContext) {
            PersistenceController.delete(viewContext, object: profile!)
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
