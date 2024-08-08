//
//  EditRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditRoutineViewModel: ViewModel, AddingViewModel, EditingViewModel, DefaultValueViewModel {
    
    @Published public var showRoutineChangedAlert: Bool = false
    @Published public var showNoChangeAlert: Bool = false
    @Published public var editedRoutineName: String = ""
    @Published public var editedRoutineNameIsInvalid: Bool = false
    @Published public var editedRoutineNameIsInvalidMsg: String = ""
    @Published public var editiedRoutineDescription: String = ""
    @Published public var editedRoutineDescIsInvalid: Bool = false
    @Published public var editedRoutineDescIsInvalidMsg: String = ""
    @Published public var selectedTemplateCycle: TemplateCycle? = nil
    
    typealias T = Routine
    
    public func setViewStartValues(entity: Routine) -> Void {
        editedRoutineName = entity.timePeriodName!
        editiedRoutineDescription = entity.timePeriodDescription!
    }
    
    public func saveEdits(entity: Routine, viewContext: NSManagedObjectContext) -> Void {
        if entity.timePeriodName != editedRoutineName {
            entity.timePeriodName = editedRoutineName
        }
        
        if entity.timePeriodDescription != editiedRoutineDescription {
            entity.timePeriodDescription = editiedRoutineDescription
        }
        
        if entity.hasChanges {
            withAnimation {
                showRoutineChangedAlert = true
            }
            self.save(viewContext)
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
    }
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        let templateWeek = TemplateWeek(
            viewContext,
            templateCycle: selectedTemplateCycle!
        )
        
        // Get all training cycles
        let fetchRequest: NSFetchRequest<TrainingCycle> = TrainingCycle.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateCycle == %@", selectedTemplateCycle!)
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
        
        self.save(viewContext)
    }
}
