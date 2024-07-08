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
 
    public func createRoutine(viewContext: NSManagedObjectContext, navPath: Binding<[Int]>, selectedRoutine: Binding<Routine?>, selectedTemplateCycle: Binding<TemplateCycle?>) -> Void {
        
        // Create a Routine
        let newRoutine = Routine(context: viewContext)
        newRoutine.timePeriodName = newRoutineName
        newRoutine.timePeriodDescription = newRoutineDesc
        newRoutine.createdOnDate = Date()
        let templateCycle = TemplateCycle(context: viewContext)
        templateCycle.timePeriodName = newRoutineName
        templateCycle.routine = newRoutine
        newRoutine.templateCycle = templateCycle
        
        // reset fields
        withAnimation {
            newRoutineName = ""
            newRoutineDesc = ""
        }
        
        // Save and continue
        PersistenceController.save(viewContext)
        
        selectedRoutine.wrappedValue = newRoutine
        selectedTemplateCycle.wrappedValue = templateCycle
        
        navPath.wrappedValue.append(2)
    }
}
