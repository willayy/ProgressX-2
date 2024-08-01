//
//  ProfileViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class ProfileViewModel: SavingViewModel {
    
    @Published public var userName: String = ""
    @Published public var birthDay: Date = Date()
    @Published public var selectedUnitSegment: String = "Metric"
    @Published public var selectedGenderSegment: String = "Male"
    @Published public var height: String = ""
    @Published public var standardRestTime: String = ""
    @Published public var showMenu: Bool = false
    @Published public var userNameIsInvalid: Bool = false
    @Published public var heightIsInvalid: Bool = false
    @Published public var weightIsInvalid: Bool = false
    @Published public var standardRestTimeIsInvalid: Bool = false
    @Published public var userNameIsInvalidMsg: String = ""
    @Published public var heightIsInvalidMsg: String = ""
    @Published public var standardRestTimeIsInvalidMsg: String = ""
    @Published public var showNoChangeAlert: Bool = false
    @Published public var showProfileChangedAlert: Bool = false
    @Published public var selectedSmallestPlate: String = ""
    
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
            
            self.safeSave(viewContext: viewContext)
            
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
        
    }
    
}
