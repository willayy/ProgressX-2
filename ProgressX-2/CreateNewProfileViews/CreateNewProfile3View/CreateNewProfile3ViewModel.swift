//
//  CreateNewProfile3_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewProfile3ViewModel: ObservableObject {
    
    // Inputfield value states
    @Published var chestCirc = ""
    @Published var waistCirc = ""
    @Published var thighCirc = ""
    @Published var calfCirc = ""
    @Published var upperArmCirc = ""
    @Published var lowerArmCirc = ""
    
    // Inputfield invalid states
    @Published var chestCircIsInvalid = false
    @Published var waistCircIsInvalid = false
    @Published var thighCircIsInvalid = false
    @Published var calfCircIsInvalid = false
    @Published var upperArmCircIsInvalid = false
    @Published var lowerArmCircIsInvalid = false
    
    // Inputfield errormessage states
    @Published var chestCircIsInvalidMsg = ""
    @Published var waistCircIsInvalidMsg = ""
    @Published var thighCircIsInvalidMsg = ""
    @Published var calfCircIsInvalidMsg = ""
    @Published var upperArmCircIsInvalidMsg = ""
    @Published var lowerArmCircIsInvalidMsg = ""
    
    // Constants specific to elements in this view
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    let textWidth: Double = 200
    
    public func addExtraInfo(viewContext: NSManagedObjectContext, bodyEntries: FetchedResults<BodyEntry>) {
        let firstEntry = bodyEntries.first!
        firstEntry.chestCirc = Double(chestCirc)!
        firstEntry.waistCirc = Double(waistCirc)!
        firstEntry.thighCirc = Double(thighCirc)!
        firstEntry.calfCirc = Double(calfCirc)!
        firstEntry.uprArmCirc = Double(upperArmCirc)!
        firstEntry.lwrArmCirc = Double(lowerArmCirc)!
        PersistenceController.save(viewContext)
    }
}
