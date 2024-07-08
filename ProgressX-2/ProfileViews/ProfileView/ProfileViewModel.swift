//
//  ProfileViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class ProfileViewModel: ObservableObject {
    
    @Published var userName: String = ""
    @Published var birthDay: Date = Date()
    @Published var selectedUnitSegment: String = "Metric (meters)"
    @Published var selectedGenderSegment: String = "Male"
    @Published var height: String = ""
    @Published var standardRestTime: String = ""
    @Published var showMenu: Bool = false
    @Published var userNameIsInvalid: Bool = false
    @Published var heightIsInvalid: Bool = false
    @Published var weightIsInvalid: Bool = false
    @Published var standardRestTimeIsInvalid: Bool = false
    @Published var userNameIsInvalidMsg: String = ""
    @Published var heightIsInvalidMsg: String = ""
    @Published var standardRestTimeIsInvalidMsg: String = ""
    @Published var showNoChangeAlert: Bool = false
    @Published var showProfileChangedAlert: Bool = false
    
    let unitSegments = ["Metric (meters, kg's)", "Imperial (feet, lbs)"]
    let genderSegments = ["Male", "Female"]
    
    public func setViewStartValues(profiles: FetchedResults<Profile>) -> Void {
        let profile = profiles.first!
        standardRestTime = String(profile.standardRestTime)
        selectedUnitSegment = (profile.isMetric) ? "Metric (meters, kg's)" : "Imperial (feet, lbs)"
        height = String(profile.height)
        birthDay = profile.birthDay!
        userName = profile.profileUserName!
        selectedGenderSegment = (profile.gender == "male") ? "Male" : "Female"
    }
    
    public func saveProfileChanges(viewContext: NSManagedObjectContext, profiles: FetchedResults<Profile>) -> Void {
        
        let profile = profiles.first!
        
        if userName != profile.profileUserName {
            profile.profileUserName = userName
        }
        
        if (profile.isMetric ? "Metric (meters, kg's)" : "Imperial (feet, lbs)") != selectedUnitSegment {
            profile.isMetric = (selectedUnitSegment == "Metric (meters, kg's)") ? true : false
        }
        
        if profile.gender != (selectedGenderSegment == "Male" ? "male" : "female") {
            profile.gender = (selectedGenderSegment == "Male") ? "male" : "female"
        }
        
        if profile.height != Double(height)! {
            profile.height = Double(height)!
        }
        
        if profile.standardRestTime != Double(standardRestTime)! {
            profile.standardRestTime = Double(standardRestTime)!
        }
        
        if profile.hasChanges {
            withAnimation {
                showProfileChangedAlert = true
            }
            PersistenceController.save(viewContext)
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
        
    }
    
}
