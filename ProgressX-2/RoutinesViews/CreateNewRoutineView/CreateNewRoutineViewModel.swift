//
//  CreateNewRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewRoutineViewModel: SavingViewModel {
    
    @Published var newRoutineName: String = ""
    @Published var newRoutineNameIsInvalid: Bool = false
    @Published var newRoutineNameIsInvalidMsg: String = ""
    @Published var newRoutineDesc: String = ""
    @Published var newRoutineDescIsInvalid: Bool = false
    @Published var newRoutineDescIsInvalidMsg: String = ""
 
    public func createRoutine(viewContext: NSManagedObjectContext) -> Void {
        
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
        self.safeSave(viewContext: viewContext)
        
    }
}
