//
//  CreateNewPersonalRecordViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewPersonalRecordViewModel: ObservableObject {
    
    // Date picker value
    @Published public var prDate: Date = Date()
    // Input field vars
    @Published public var prQuantity: String = ""
    @Published public var prLoad: String = ""
    @Published public var prLoadIsInvalid: Bool = false
    @Published public var prQuantityIsInvalid: Bool = false
    @Published public var prLoadIsInvalidMsg: String = ""
    @Published public var prQuantityIsInvalidMsg: String = ""
    // Segment picker options
    private let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    public func createNewPersonalRecord(viewContext: NSManagedObjectContext, exercise: Exercise, prType: String) -> Void {
        // Create the PR
        let _: PersonalRecord = PersonalRecord(
            viewContext,
            exercise: exercise,
            weightLoad: Double(prLoad)!,
            quantity: Double(prQuantity)!,
            date: prDate,
            type: prType
        )
        
        PersistenceController.save(viewContext)
        
        // Reset the view state with an animation
        withAnimation {
            prDate = Date()
            prLoad = ""
            prQuantity = ""
        }
        
    }
    
}
