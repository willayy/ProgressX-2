//
//  CreateNewProfile3_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewProfile3ViewModel: ViewModel {
    
    // Inputfield value states
    @Published public var chestCirc = ""
    @Published public var waistCirc = ""
    @Published public var thighCirc = ""
    @Published public var calfCirc = ""
    @Published public var upperArmCirc = ""
    @Published public var lowerArmCirc = ""
    
    // Variable needed for saveEntry
    @Published public var firstBodyEntry: BodyEntry? = nil
    
    // Constants specific to elements in this view
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    let textWidth: Double = 200
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        let bodyEntry = self.firstBodyEntry!
        bodyEntry.chestCirc = NSNumber(value: Double(self.chestCirc)!)
        bodyEntry.waistCirc = NSNumber(value: Double(self.waistCirc)!)
        bodyEntry.thighCirc = NSNumber(value: Double(self.thighCirc)!)
        bodyEntry.calfCirc = NSNumber(value: Double(self.calfCirc)!)
        bodyEntry.uprArmCirc = NSNumber(value: Double(self.upperArmCirc)!)
        bodyEntry.lwrArmCirc = NSNumber(value: Double(self.lowerArmCirc)!)
        self.save(viewContext)
    }
}
