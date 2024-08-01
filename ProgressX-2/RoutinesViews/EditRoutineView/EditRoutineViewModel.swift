//
//  EditRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditRoutineViewModel: SavingViewModel {
    
    @Published var showRoutineChangedAlert: Bool = false
    @Published var showNoChangeAlert: Bool = false
    @Published var editedRoutineName: String = ""
    @Published var editedRoutineNameIsInvalid: Bool = false
    @Published var editedRoutineNameIsInvalidMsg: String = ""
    @Published var editiedRoutineDescription: String = ""
    @Published var editedRoutineDescIsInvalid: Bool = false
    @Published var editedRoutineDescIsInvalidMsg: String = ""
    
    public func setViewStartValues(selectedRoutine: Routine) -> Void {
        editedRoutineName = selectedRoutine.timePeriodName!
        editiedRoutineDescription = selectedRoutine.timePeriodDescription!
    }
    
    public func saveRoutineChanges(viewContext: NSManagedObjectContext, selectedRoutine: Routine) -> Void {
        if selectedRoutine.timePeriodName != editedRoutineName {
            selectedRoutine.timePeriodName = editedRoutineName
        }
        
        if selectedRoutine.timePeriodDescription != editiedRoutineDescription {
            selectedRoutine.timePeriodDescription = editiedRoutineDescription
        }
        
        if selectedRoutine.hasChanges {
            withAnimation {
                showRoutineChangedAlert = true
            }
            PersistenceController.save(viewContext)
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
    }
    
    public func addWeek(viewContext: NSManagedObjectContext, selectedTemplateCycle: TemplateCycle) -> Void {
        let templateWeek = TemplateWeek(
            viewContext,
            templateCycle: selectedTemplateCycle
        )
        
        // Get all training cycles
        let fetchRequest: NSFetchRequest<TrainingCycle> = TrainingCycle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateCycle == %@", selectedTemplateCycle)
        // Only included incomplete trainingCycles as completed ones are irrelevant for this change
        let trainingCycles = PersistenceController.fetch(viewContext, fetchRequest: fetchRequest)
            .filter({ !$0.isComplete })
        
        // Add training cycles to them
        for trainingCycle in trainingCycles {
            let _ = TrainingWeek(
                viewContext,
                trainingCycle: trainingCycle,
                templateWeek: templateWeek
            )
        }
        
        self.safeSave(viewContext: viewContext)
    }
    
    
    
}
