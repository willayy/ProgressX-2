//
//  EditPrViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class EditPrViewModel: ObservableObject {
    
    // Input field vars
    @Published public var newDate: Date = Date()
    @Published public var newQuantity: String = ""
    @Published public var newWeightLoad: String = ""
    @Published public var newQuantityInvalid: Bool = false
    @Published public var newWeightLoadInvalid: Bool = false
    @Published public var newQuantityInvalidMsg: String = ""
    @Published public var newWeightLoadInvalidMsg: String = ""
    // Alert vars
    @Published public var prEditedAlert: Bool = false
    @Published public var noChangeAlert: Bool = false
    
    public func setViewStartValues(editingPr: PersonalRecord?) -> Void {
        newDate = editingPr!.achievedOnDate!
        newWeightLoad = String(editingPr!.weightLoad)
        newQuantity = String(Int(editingPr!.prQuantity))
    }
    
    public func savePersonalRecordChanges(viewContext: NSManagedObjectContext, editingPr: PersonalRecord?) -> Void {
        
        if editingPr!.weightLoad != Double(newWeightLoad) {
            editingPr!.weightLoad = Double(newWeightLoad)!
        }
            
        if editingPr!.prQuantity != Double(newQuantity) {
            editingPr!.prQuantity = Double(newQuantity)!
        }
            
        if editingPr!.achievedOnDate != newDate {
            editingPr!.achievedOnDate = newDate
        }
        
        if editingPr!.hasChanges {
            withAnimation {
                prEditedAlert = true
            }
            PersistenceController.save(viewContext)
        } else {
            withAnimation {
                noChangeAlert = true
            }
        }
    }
    
}
