//
//  EditRoutineViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditRoutineViewModel: ObservableObject {
    
    @Published var showRoutineChangedAlert: Bool = false
    @Published var showNoChangeAlert: Bool = false
    @Published var showChangeInfo: Bool = false
    @Published var editedRoutineName: String = ""
    @Published var editedRoutineNameIsInvalid: Bool = false
    @Published var editedRoutineNameIsInvalidMsg: String = ""
    @Published var editiedRoutineDescription: String = ""
    @Published var editedRoutineDescIsInvalid: Bool = false
    @Published var editedRoutineDescIsInvalidMsg: String = ""
    
    public func setViewStartValues(selectedRoutine: Routine?) -> Void {
        editedRoutineName = selectedRoutine!.timePeriodName!
        editiedRoutineDescription = selectedRoutine!.timePeriodDescription!
    }
    
    public func saveRoutineChanges(viewContext: NSManagedObjectContext, selectedRoutine: Routine?) -> Void {
        if selectedRoutine!.timePeriodName != editedRoutineName {
            selectedRoutine!.timePeriodName = editedRoutineName
        }
        
        if selectedRoutine!.timePeriodDescription != editiedRoutineDescription {
            selectedRoutine!.timePeriodDescription = editiedRoutineDescription
        }
        
        if selectedRoutine!.hasChanges {
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
    
    public func addWeek(viewContext: NSManagedObjectContext, selectedTemplateCycle: TemplateCycle?) -> Void {
        let positionIndex = selectedTemplateCycle!.getNextPositionIndex()
        _ = PersistenceController.createTemplateWeek(
            viewContext,
            name: "Week \(positionIndex)",
            templateCycle: selectedTemplateCycle!,
            positionIndex: positionIndex
        )
        PersistenceController.save(viewContext)
    }
    
    
    
}
