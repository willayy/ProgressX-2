//
//  EditWeighInViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import Foundation
import CoreData
import SwiftUI

class EditWeighInViewModel: SavingViewModel {
    
    @Published public var bodyEntryEditedAlert: Bool = false
    @Published public var noChangeAlert: Bool = false
    @Published public var editedDate: Date = Date()
    @Published public var editedBodyWeight: String = ""
    @Published public var editedBodyWeightIsInvalid: Bool = false
    @Published public var editedBodyWeightIsInvalidMsg: String = ""
    @Published public var editedChestCirc: String = ""
    @Published public var editedChestCircIsInvalid: Bool = false
    @Published public var editedChestCircIsInvalidMsg: String = ""
    @Published public var editedWaistCirc: String = ""
    @Published public var editedWaistCircIsInvalid: Bool = false
    @Published public var editedWaistCircIsInvalidMsg: String = ""
    @Published public var editedUpperArmCirc: String = ""
    @Published public var editedUpperArmCircIsInvalid: Bool = false
    @Published public var editedUpperArmCircIsInvalidMsg: String = ""
    @Published public var editedLowerArmCirc: String = ""
    @Published public var editedLowerArmIsInvalid: Bool = false
    @Published public var editedLowerArmIsInvalidMsg: String = ""
    @Published public var editedThighCirc: String = ""
    @Published public var editedThighCircIsInvalid: Bool = false
    @Published public var editedThighCircIsInvalidMsg: String = ""
    @Published public var editedCalfCirc: String = ""
    @Published public var editedCalfCircIsInvalid: Bool = false
    @Published public var editedCalfCircIsInvalidMsg: String = ""
    
    public func setViewStartValues(bodyEntry: BodyEntry) -> Void {
        editedDate = bodyEntry.achievedOnDate!
        editedBodyWeight = String(format: "%.2f", bodyEntry.bodyWeight)
        editedChestCirc = (bodyEntry.chestCirc == nil) ? "" : String(describing: bodyEntry.chestCirc!)
        editedUpperArmCirc = (bodyEntry.uprArmCirc == nil) ? "" : String(describing: bodyEntry.uprArmCirc!)
        editedLowerArmCirc = (bodyEntry.lwrArmCirc == nil) ? "" : String(describing: bodyEntry.lwrArmCirc!)
        editedWaistCirc = (bodyEntry.waistCirc == nil) ? "" : String(describing: bodyEntry.waistCirc!)
        editedThighCirc = (bodyEntry.thighCirc == nil) ? "" : String(describing: bodyEntry.thighCirc!)
        editedCalfCirc = (bodyEntry.calfCirc == nil) ? "" : String(describing: bodyEntry.calfCirc!)
    }
    
    public func saveBodyEntryChanges(bodyEntry: BodyEntry, viewContext: NSManagedObjectContext) -> Void {
        
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
            withAnimation {
                bodyEntryEditedAlert = true
            }
            
            self.safeSave(viewContext: viewContext)
            
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
        
    }
    
}
