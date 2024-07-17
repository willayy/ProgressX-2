//
//  CreateNewRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class CreateNewRoutineViewModel: ObservableObject {
    
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
        let templateCycle = TemplateCycle(
            viewContext,
            routine: newRoutine
        )
        
        newRoutine.templateCycle = templateCycle
        
        // Create a TrainingCycle to add
        let trainingCycle = TrainingCycle(
            viewContext,
            routine: newRoutine
        )
        
        newRoutine.addToTrainingCycles(trainingCycle)
        
        // reset fields
        withAnimation {
            newRoutineName = ""
            newRoutineDesc = ""
        }
        
        // Save and continue
        PersistenceController.save(viewContext)
        
    }
}
