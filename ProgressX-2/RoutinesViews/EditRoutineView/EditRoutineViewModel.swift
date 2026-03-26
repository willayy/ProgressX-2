//
//  EditRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditRoutineViewModel: ViewModel {
    
    @Published public var showRoutineChangedAlert: Bool = false
    
    @Published public var showNoChangeAlert: Bool = false
    
    @Published public var editedRoutineName: String = ""
    
    @Published public var editedRoutineDescription: String = ""
    
    @Published public var selectedTemplateCycle: TemplateCycle? = nil
        
    public func setViewStartValues(entity: Routine) -> Void {
        self.editedRoutineName = entity.timePeriodName!
        self.editedRoutineDescription = entity.timePeriodDescription!
    }
    
    public func saveEdits(entity: Routine, viewContext: NSManagedObjectContext) -> Void {
        if entity.timePeriodName != self.editedRoutineName {
            entity.timePeriodName = self.editedRoutineName
        }
        
        if entity.timePeriodDescription != self.editedRoutineDescription {
            entity.timePeriodDescription = self.editedRoutineDescription
        }
        
        if entity.hasChanges {
            
            withAnimation {
                self.showRoutineChangedAlert = true
            }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation {
                self.showNoChangeAlert = true
            }
            
        }
    }
    
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        let templateWeek = TemplateWeek(
            viewContext,
            templateCycle: selectedTemplateCycle!
        )
    
        // Only included incomplete trainingCycles as completed ones are irrelevant for this change
        let trainingCycles = selectedTemplateCycle!.trainingCycles?.allObjects as! [TrainingCycle]
        
        // Add weeks cycles to them
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
