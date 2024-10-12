//
//  ProfileViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class ProfileViewModel: ViewModel, EditingViewModel, DefaultValueViewModel {
    
    // Segmented picker variables
    @Published public var selectedUnitSegment: Bool = true
    @Published public var selectedGenderSegment: String = "male"
    
    // Input variables
    @Published public var userName: String = ""
    @Published public var birthDay: Date = Date()
    @Published public var height: String = ""
    @Published public var standardRestTime: String = ""
    @Published public var selectedSmallestPlate: String = ""
    
    // Submission alert states
    @Published public var showNoChangeAlert: Bool = false
    @Published public var showProfileChangedAlert: Bool = false
    
    typealias T = Profile
    
    // Segments for segment picker
    let unitSegments: KeyValueList<String, Bool> = KeyValueList([
        ("Metric",true),
        ("Imperial",false)
    ])
    
    let genderSegments: KeyValueList<String, String> = KeyValueList([
        ("Male","male"),
        ("Female","female")
    ])
    
    var smallestPlateSegments: [String] {
        
        if selectedUnitSegment {
            
            return ["1.25 kg's", "2.5 kg's", "5 kg's", "10 kg's"]
            
        } else {
            
            return ["2.5 lbs", "5 lbs", "10 lbs"]
            
        }
    }
    
    public func setViewStartValues(entity: Profile) -> Void {
        
        self.standardRestTime = String(format: "%.2f", entity.standardRestTime)
        
        self.selectedUnitSegment = selectedUnitSegment
        
        self.height = String(format: "%.2f", entity.userHeight)
        
        self.birthDay = entity.birthDay!
        
        self.userName = entity.profileUserName!
        
        self.selectedGenderSegment = selectedGenderSegment
        
        self.selectedSmallestPlate = {
            
            if entity.isMetric {
                
                return "\(entity.smallestPlate) kg's"
                
            } else {
                
                return "\(entity.smallestPlate) lbs"
                
            }
        }()
    }
    
    public func saveEdits(entity: Profile, viewContext: NSManagedObjectContext) -> Void {
                
        if userName != entity.profileUserName {
            
            entity.profileUserName = userName
            
        }
        
        if entity.isMetric != selectedUnitSegment {
            
            entity.isMetric = selectedUnitSegment
            
        }
        
        if entity.gender != selectedGenderSegment {
            
            entity.gender = selectedGenderSegment
            
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
            
            withAnimation { showProfileChangedAlert = true }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation { showNoChangeAlert = true }
            
        }
        
    }
    
}
