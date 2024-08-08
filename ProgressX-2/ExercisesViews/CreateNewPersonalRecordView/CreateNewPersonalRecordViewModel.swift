//
//  CreateNewPersonalRecordViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewPersonalRecordViewModel: ViewModel, AddingViewModel {
    
    // Date picker value
    @Published public var prDate: Date = Date()
    
    // Input field vars
    @Published public var prQuantity: String = ""
    @Published public var prLoad: String = ""
    
    // Input is invalid vars
    @Published public var prLoadIsInvalid: Bool = false
    @Published public var prQuantityIsInvalid: Bool = false
    
    // Input is invalid message vars
    @Published public var prLoadIsInvalidMsg: String = ""
    @Published public var prQuantityIsInvalidMsg: String = ""
    
    // Vars for saveEntry()
    @Published public var selectedPrType: String? = nil
    @Published public var selectedExercise: Exercise? = nil

    // Segment picker options
    private let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        // Create the PR
        let _: PersonalRecord = PersonalRecord(
            viewContext,
            exercise: selectedExercise!,
            weightLoad: Double(prLoad)!,
            quantity: Double(prQuantity)!,
            date: prDate,
            type: selectedPrType!
        )
        
        self.save(viewContext)
        
        // Reset the view state with an animation
        withAnimation {
            prDate = Date()
            prLoad = ""
            prQuantity = ""
        }
    }
}
