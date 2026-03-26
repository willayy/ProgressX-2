//
//  EditWeighInViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import Foundation
import CoreData
import SwiftUI

class EditWeighInViewModel: ViewModel {
    
    // Submission alert variables
    @Published public var bodyEntryEditedAlert: Bool = false
    
    @Published public var noChangeAlert: Bool = false
    
    // Input variables
    @Published public var editedDate: Date = Date()
    
    @Published public var editedBodyWeight: String = ""
    
    @Published public var editedChestCirc: String = ""
    
    @Published public var editedWaistCirc: String = ""
    
    @Published public var editedUpperArmCirc: String = ""
    
    @Published public var editedLowerArmCirc: String = ""
    
    @Published public var editedThighCirc: String = ""
    
    @Published public var editedCalfCirc: String = ""
    
    public func setViewStartValues(entity: BodyEntry) -> Void {
        
        editedDate = entity.achievedOnDate!
        
        editedBodyWeight = String(format: "%.2f", entity.bodyWeight)
        
        editedChestCirc = (entity.chestCirc == nil) ? "" : String(describing: entity.chestCirc!)
        
        editedUpperArmCirc = (entity.uprArmCirc == nil) ? "" : String(describing: entity.uprArmCirc!)
        
        editedLowerArmCirc = (entity.lwrArmCirc == nil) ? "" : String(describing: entity.lwrArmCirc!)
        
        editedWaistCirc = (entity.waistCirc == nil) ? "" : String(describing: entity.waistCirc!)
        
        editedThighCirc = (entity.thighCirc == nil) ? "" : String(describing: entity.thighCirc!)
        
        editedCalfCirc = (entity.calfCirc == nil) ? "" : String(describing: entity.calfCirc!)
        
    }
    
    public func saveBodyEntryEdit(bodyEntry: BodyEntry, context: NSManagedObjectContext) -> Void {
        
        if editedDate != bodyEntry.achievedOnDate! {
            bodyEntry.achievedOnDate = editedDate
        }
        
        if Double(editedBodyWeight) != bodyEntry.bodyWeight {
            bodyEntry.bodyWeight = Double(editedBodyWeight)!
        }
        
        let editedChestCirc = self.editedChestCirc.isEmpty ? nil : NSNumber(value: Double(self.editedChestCirc)!)
        if editedChestCirc != bodyEntry.chestCirc {
            bodyEntry.chestCirc = editedChestCirc
        }
        
        let editedUpperArmCirc = self.editedUpperArmCirc.isEmpty ? nil : NSNumber(value: Double(self.editedUpperArmCirc)!)
        if editedUpperArmCirc != bodyEntry.uprArmCirc {
            bodyEntry.uprArmCirc = editedUpperArmCirc
        }
        
        let editedLowerArmCirc = self.editedLowerArmCirc.isEmpty ? nil : NSNumber(value: Double(self.editedLowerArmCirc)!)
        if editedLowerArmCirc != bodyEntry.lwrArmCirc {
            bodyEntry.lwrArmCirc = editedLowerArmCirc
        }
        
        let editedWaistCirc = self.editedWaistCirc.isEmpty ? nil : NSNumber(value: Double(self.editedWaistCirc)!)
        if editedWaistCirc != bodyEntry.waistCirc {
            bodyEntry.waistCirc = editedWaistCirc
        }
        
        let editedThighCirc = self.editedThighCirc.isEmpty ? nil : NSNumber(value: Double(self.editedThighCirc)!)
        if editedThighCirc != bodyEntry.thighCirc {
            bodyEntry.thighCirc = editedThighCirc
        }
        
        let editedCalfCirc = self.editedCalfCirc.isEmpty ? nil : NSNumber(value: Double(self.editedCalfCirc)!)
        if editedCalfCirc != bodyEntry.calfCirc {
            bodyEntry.calfCirc = editedCalfCirc
        }
        
        if bodyEntry.hasChanges {
            
            withAnimation { bodyEntryEditedAlert = true }
            
            self.save(context)
            
        } else {
            
            withAnimation { noChangeAlert = true }
            
        }
        
    }
    
}
