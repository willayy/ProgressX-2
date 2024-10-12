//
//  CreateNewRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewRoutineViewModel: ViewModel, AddingViewModel {
    
    @Published var newRoutineName: String = ""
    
    @Published var newRoutineDesc: String = ""
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        // Create a Routine
        let newRoutine = Routine(
            viewContext,
            name: newRoutineName,
            description: newRoutineDesc
        )
        
        // Create a TemplateCycle to add
        let _ = TemplateCycle(
            viewContext,
            routine: newRoutine
        )
        
        // Create a TrainingCycle to add
        let _ = TrainingCycle(
            viewContext,
            routine: newRoutine
        )
        
        // reset fields
        withAnimation {
            newRoutineName = ""
            newRoutineDesc = ""
        }
        
        // Save and continue
        self.save(viewContext)
        
    }
}
