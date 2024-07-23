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
    @Published var selectedUnitSegment: String = "Metric"
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
    @Published var selectedSmallestPlate: String = ""
    
    let unitSegments = ["Metric", "Imperial"]
    let genderSegments = ["Male", "Female"]
    var smallestPlateSegments: [String] {
        if selectedUnitSegment == "Metric" {
            return ["1.25 kg's", "2.5 kg's", "5 kg's", "10 kg's"]
        } else {
            return ["2.5 lbs", "5 lbs", "10 lbs"]
        }
    }
    
    public func setViewStartValues(profiles: FetchedResults<Profile>) -> Void {
        let profile = profiles.first!
        self.standardRestTime = String(profile.standardRestTime)
        self.selectedUnitSegment = (profile.isMetric) ? "Metric" : "Imperial"
        self.height = String(profile.userHeight)
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
    
    public func saveProfileChanges(viewContext: NSManagedObjectContext, profiles: FetchedResults<Profile>) -> Void {
        
        let profile = profiles.first!
        
        if userName != profile.profileUserName {
            profile.profileUserName = userName
        }
        
        if (profile.isMetric ? "Metric" : "Imperial") != selectedUnitSegment {
            profile.isMetric = (selectedUnitSegment == "Metric") ? true : false
        }
        
        if profile.gender != (selectedGenderSegment == "Male" ? "male" : "female") {
            profile.gender = (selectedGenderSegment == "Male") ? "male" : "female"
        }
        
        if profile.userHeight != Double(height)! {
            profile.userHeight = Double(height)!
        }
        
        if profile.standardRestTime != Double(standardRestTime)! {
            profile.standardRestTime = Double(standardRestTime)!
        }
        
        let smallestPlate = {
            let numericalValue: String = self.selectedSmallestPlate
                .replacingOccurrences(of: " kg's", with: "")
                .replacingOccurrences(of: " lbs", with: "")
            return Double(numericalValue)!
        }()
        
        if profile.smallestPlate != smallestPlate {
            profile.smallestPlate = smallestPlate
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
