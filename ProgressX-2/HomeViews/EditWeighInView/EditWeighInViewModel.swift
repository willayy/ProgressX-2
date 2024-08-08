//
//  EditWeighInViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import Foundation
import CoreData
import SwiftUI

class EditWeighInViewModel: ViewModel, EditingViewModel, DefaultValueViewModel {
    
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

    // Invalid input variables
    @Published public var editedBodyWeightIsInvalid: Bool = false
    @Published public var editedChestCircIsInvalid: Bool = false
    @Published public var editedWaistCircIsInvalid: Bool = false
    @Published public var editedUpperArmCircIsInvalid: Bool = false
    @Published public var editedLowerArmIsInvalid: Bool = false
    @Published public var editedThighCircIsInvalid: Bool = false
    @Published public var editedCalfCircIsInvalid: Bool = false

    // Invalid input message variables
    @Published public var editedBodyWeightIsInvalidMsg: String = ""
    @Published public var editedChestCircIsInvalidMsg: String = ""
    @Published public var editedWaistCircIsInvalidMsg: String = ""
    @Published public var editedUpperArmCircIsInvalidMsg: String = ""
    @Published public var editedLowerArmIsInvalidMsg: String = ""
    @Published public var editedThighCircIsInvalidMsg: String = ""
    @Published public var editedCalfCircIsInvalidMsg: String = ""
    
    typealias T = BodyEntry
    
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
    
    public func saveEdits(entity: BodyEntry, viewContext: NSManagedObjectContext) -> Void {
        
        if editedDate != entity.achievedOnDate! {
            entity.achievedOnDate = editedDate
        }
        
        if Double(editedBodyWeight) != entity.bodyWeight {
            entity.bodyWeight = Double(editedBodyWeight)!
        }
        
        let editedChestCirc = self.editedChestCirc.isEmpty ? nil : NSNumber(value: Double(self.editedChestCirc)!)
        if editedChestCirc != entity.chestCirc {
            entity.chestCirc = editedChestCirc
        }
        
        let editedUpperArmCirc = self.editedUpperArmCirc.isEmpty ? nil : NSNumber(value: Double(self.editedUpperArmCirc)!)
        if editedUpperArmCirc != entity.uprArmCirc {
            entity.uprArmCirc = editedUpperArmCirc
        }
        
        let editedLowerArmCirc = self.editedLowerArmCirc.isEmpty ? nil : NSNumber(value: Double(self.editedLowerArmCirc)!)
        if editedLowerArmCirc != entity.lwrArmCirc {
            entity.lwrArmCirc = editedLowerArmCirc
        }
        
        let editedWaistCirc = self.editedWaistCirc.isEmpty ? nil : NSNumber(value: Double(self.editedWaistCirc)!)
        if editedWaistCirc != entity.waistCirc {
            entity.waistCirc = editedWaistCirc
        }
        
        let editedThighCirc = self.editedThighCirc.isEmpty ? nil : NSNumber(value: Double(self.editedThighCirc)!)
        if editedThighCirc != entity.thighCirc {
            entity.thighCirc = editedThighCirc
        }
        
        let editedCalfCirc = self.editedCalfCirc.isEmpty ? nil : NSNumber(value: Double(self.editedCalfCirc)!)
        if editedCalfCirc != entity.calfCirc {
            entity.calfCirc = editedCalfCirc
        }
        
        if entity.hasChanges {
            withAnimation { bodyEntryEditedAlert = true }
            self.save(viewContext)
        } else {
            withAnimation { noChangeAlert = true }
        }
        
    }
    
}
