//
//  ProfileViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class ProfileViewModel: SavingViewModel, EditingViewModel {
    
    // Segmented picker variables
    @Published public var selectedUnitSegment: String = "Metric"
    @Published public var selectedGenderSegment: String = "Male"
    
    // Input variables
    @Published public var userName: String = ""
    @Published public var birthDay: Date = Date()
    @Published public var height: String = ""
    @Published public var standardRestTime: String = ""
    @Published public var selectedSmallestPlate: String = ""
    
    // Submission alert states
    @Published public var showNoChangeAlert: Bool = false
    @Published public var showProfileChangedAlert: Bool = false
    
    // Ivalid input variables
    @Published public var userNameIsInvalid: Bool = false
    @Published public var heightIsInvalid: Bool = false
    @Published public var weightIsInvalid: Bool = false
    @Published public var standardRestTimeIsInvalid: Bool = false
    
    // Error message variables
    @Published public var userNameIsInvalidMsg: String = ""
    @Published public var heightIsInvalidMsg: String = ""
    @Published public var standardRestTimeIsInvalidMsg: String = ""
    
    // Segments for segment picker
    let unitSegments = ["Metric", "Imperial"]
    let genderSegments = ["Male", "Female"]
    
    var smallestPlateSegments: [String] {
        if selectedUnitSegment == "Metric" {
            return ["1.25 kg's", "2.5 kg's", "5 kg's", "10 kg's"]
        } else {
            return ["2.5 lbs", "5 lbs", "10 lbs"]
        }
    }
    
    public func setViewStartValues(profile: Profile) -> Void {
        self.standardRestTime = String(format: "%.2f", profile.standardRestTime)
        self.selectedUnitSegment = (profile.isMetric) ? "Metric" : "Imperial"
        self.height = String(format: "%.2f", profile.userHeight)
        self.birthDay = profile.birthDay!
        self.userName = profile.profileUserName!
        self.selectedGenderSegment = (profile.gender == "male") ? "Male" : "Female"
        self.selectedSmallestPlate = {
            if profile.isMetric {
                return "\(profile.smallestPlate) kg's"
            } else {
                return "\(profile.smallestPlate) lbs"
            }
        }()
    }
    
    typealias T = Profile
    
    public func saveEdits(entity: Profile, viewContext: NSManagedObjectContext) -> Void {
                
        if userName != entity.profileUserName {
            entity.profileUserName = userName
        }
        
        if (entity.isMetric ? "Metric" : "Imperial") != selectedUnitSegment {
            entity.isMetric = (selectedUnitSegment == "Metric") ? true : false
        }
        
        if entity.gender != (selectedGenderSegment == "Male" ? "male" : "female") {
            entity.gender = (selectedGenderSegment == "Male") ? "male" : "female"
        }
        
        if entity.userHeight != Double(height)! {
            entity.userHeight = Double(height)!
        }
        
        if entity.standardRestTime != Double(standardRestTime)! {
            entity.standardRestTime = Double(standardRestTime)!
        }
        
        let smallestPlate = {
            let numericalValue: String = self.selectedSmallestPlate
                .replacingOccurrences(of: " kg's", with: "")
                .replacingOccurrences(of: " lbs", with: "")
            return Double(numericalValue)!
        }()
        
        if entity.smallestPlate != smallestPlate {
            entity.smallestPlate = smallestPlate
        }
        
        if entity.hasChanges {
            withAnimation {
                showProfileChangedAlert = true
            }
            
            self.safeSave(viewContext: viewContext)
            
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
        
    }
    
}
