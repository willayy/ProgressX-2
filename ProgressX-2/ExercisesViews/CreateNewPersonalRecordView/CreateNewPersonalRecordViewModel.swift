//
//  CreateNewPersonalRecordViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-08.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewPersonalRecordViewModel: ViewModel {
    
    // Date picker value
    @Published public var prDate: Date = Date()
    
    // Input field vars
    @Published public var prQuantity: String = ""
    
    @Published public var prLoad: String = ""
    
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
    
    /// Sets the quantity fo the PR based on what the prType is
    public func setPrQuantity(basedOn: String) -> Void {
        
        if basedOn == PersonalRecordType.OneRepMax.rawValue {
            
            self.prQuantity = "1"
            
        }
        
    }
    
    /// Gets the correct variant depending on what type the personal record is.
    public func getInputFieldVariant(fromPrType: String) -> InputFieldVariant {
        
        // Check which type the PR should be
        if fromPrType == PersonalRecordType.MaxReps.rawValue {
            
            return IntegerIF(min: 0, max: 100000)
            
            
        }
        
        else if fromPrType == PersonalRecordType.TimeMax.rawValue {
            
            return DecimalIF(min: 0, max: 100000)

        }
        
        // Catch statement that will never occur but is needed for the static type checker
        fatalError("local view variable prType should be timemax or maxreps but was: \(fromPrType)")
        
    }
    
    /// Gets the correct placeholder depending on what type the personal record is.
    public func getInputFieldPlaceholder(fromPrType: String) -> String {
        
        // Check which type the PlaceHolder should be
        if fromPrType == PersonalRecordType.MaxReps.rawValue {
            
            return "Reps"
            
        }
        
        else if fromPrType == PersonalRecordType.TimeMax.rawValue {
            
            return "Seconds"

        }
        
        // Catch statement that will never occur but is needed for the static type checker
        fatalError("local view variable prType should be timemax or maxreps but was: \(fromPrType)")
        
    }
    
}
