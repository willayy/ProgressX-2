//
//  CreateNewProfile3_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewProfile3ViewModel: SavingViewModel, AddingViewModel {
    
    // Inputfield value states
    @Published public var chestCirc = ""
    @Published public var waistCirc = ""
    @Published public var thighCirc = ""
    @Published public var calfCirc = ""
    @Published public var upperArmCirc = ""
    @Published public var lowerArmCirc = ""
    
    // Inputfield invalid states
    @Published public var chestCircIsInvalid = false
    @Published public var waistCircIsInvalid = false
    @Published public var thighCircIsInvalid = false
    @Published public var calfCircIsInvalid = false
    @Published public var upperArmCircIsInvalid = false
    @Published public var lowerArmCircIsInvalid = false
    
    // Inputfield errormessage states
    @Published public var chestCircIsInvalidMsg = ""
    @Published public var waistCircIsInvalidMsg = ""
    @Published public var thighCircIsInvalidMsg = ""
    @Published public var calfCircIsInvalidMsg = ""
    @Published public var upperArmCircIsInvalidMsg = ""
    @Published public var lowerArmCircIsInvalidMsg = ""
    
    // Variable needed for saveEntry
    @Published public var firstBodyEntry: BodyEntry? = nil
    
    // Constants specific to elements in this view
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    let textWidth: Double = 200
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        let firstBodyEntry = firstBodyEntry!
        firstBodyEntry.chestCirc = NSNumber(value: Double(chestCirc)!)
        firstBodyEntry.waistCirc = NSNumber(value: Double(waistCirc)!)
        firstBodyEntry.thighCirc = NSNumber(value: Double(thighCirc)!)
        firstBodyEntry.calfCirc = NSNumber(value: Double(calfCirc)!)
        firstBodyEntry.uprArmCirc = NSNumber(value: Double(upperArmCirc)!)
        firstBodyEntry.lwrArmCirc = NSNumber(value: Double(lowerArmCirc)!)
        self.safeSave(viewContext: viewContext)
    }
}
