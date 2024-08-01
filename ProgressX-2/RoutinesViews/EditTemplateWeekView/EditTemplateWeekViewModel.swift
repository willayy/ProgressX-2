//
//  EditTemplateWeek_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class EditTemplateWeekViewModel: ObservableObject {
    
    @Published var showWeekChangedAlert: Bool = false
    @Published var showNoChangeAlert: Bool = false
    @Published var editedWeekName: String = ""
    @Published var editedWeekIsInvalid: Bool = false
    @Published var editedWeekNameIsInvalidMsg: String = ""
    @Published var editedWeekDescription: String = ""
    @Published var editedWeekDescIsInvalid: Bool = false
    @Published var editedWeekDescIsInvalidMsg: String = ""
    @Published var editedPositionIndex: Int64 = 0
    
    /// Get the positionIndexes for all weeks in this Routine
    public func positionIndexes(selectedTemplateWeek: TemplateWeek) -> [Int64] {
        let cycle = selectedTemplateWeek.templateCycle!
        let weeks = cycle.templateWeeks!.allObjects as! [TemplateWeek]
        let positionIndexes = weeks.map { week in
            week.positionIndex
        }
        return positionIndexes.sorted()
    }
    
    public func setViewStartValues(week: TemplateWeek) {
        editedWeekName = week.timePeriodName!
        editedWeekDescription = week.timePeriodDescription!
        editedPositionIndex = week.positionIndex
    }
    
    /// Saves changes made to template and propogates them forwars to all matching TrainingSessions.
    public func saveTemplateWeekChanges(viewContext: NSManagedObjectContext, selectedTemplateWeek: TemplateWeek) -> Void {
        
        if selectedTemplateWeek.timePeriodName != editedWeekName {
            selectedTemplateWeek.timePeriodName = editedWeekName
        }
        
        if selectedTemplateWeek.timePeriodDescription != editedWeekDescription {
            selectedTemplateWeek.timePeriodDescription = editedWeekDescription
        }
        
        if selectedTemplateWeek.positionIndex != editedPositionIndex {
            // Find the week with the same position index in the parent routine.
            let weeksInParentRoutine = selectedTemplateWeek.templateCycle!.templateWeeks!.allObjects as! [TemplateWeek]
            let switchWithWeek = weeksInParentRoutine.first(
                where: {
                    ($0 as AnyObject).positionIndex == editedPositionIndex
                }
            )
            // Switch position index with the week
            switchWithWeek!.positionIndex = selectedTemplateWeek.positionIndex
            selectedTemplateWeek.positionIndex = editedPositionIndex
        }
        
        if selectedTemplateWeek.hasChanges {
            // propogates change to matching trainingWeeks.
            propogateChanges(viewContext, selectedTemplateWeek: selectedTemplateWeek)
            
            withAnimation {
                showWeekChangedAlert = true
                PersistenceController.save(viewContext)
            }
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
    }
    
    /// Propogating changes made to the TemplateWeek to all matching trainingWeeks
    private func propogateChanges(_ viewContext: NSManagedObjectContext, selectedTemplateWeek: TemplateWeek) -> Void {
        let changes = selectedTemplateWeek.changedValues() // Get changes
        let fetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateWeek == %@", selectedTemplateWeek)
        
        // Fetch all incomplete weeks as these are the only ones affected
        let trainingWeeks = PersistenceController.fetch(viewContext, fetchRequest: fetchRequest)
            .filter({!$0.isComplete})
        
        for trainingWeek in trainingWeeks {
            if let timePeriodName = changes["timePeriodName"] {
                trainingWeek.timePeriodName = (timePeriodName as! String)
            }
            
            if let timePeriodDesc = changes["timePeriodDescription"] {
                trainingWeek.timePeriodName = timePeriodDesc as? String
            }
            
            if let positionIndex = changes["positionIndex"] {
                trainingWeek.positionIndex = positionIndex as! Int64
            }
        }
    }
    
    /// Adds a session to the template and all incomplete matching TrainingWeeks
    public func addSession(viewContext: NSManagedObjectContext, selectedTemplateWeek: TemplateWeek) -> Void {
        let session = TemplateSession(
            viewContext,
            templateWeek: selectedTemplateWeek
        )
        
        // Get all trainingWeeks
        let fetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateWeek == %@", selectedTemplateWeek)
        // Only included incomplete trainingWeeks as completed ones are irrelevant for this change
        let trainingWeeks = PersistenceController.fetch(viewContext, fetchRequest: fetchRequest)
            .filter({ !$0.isComplete })
        
        for trainingWeek in trainingWeeks {
            let _ = TrainingSession(
                viewContext,
                trainingWeek: trainingWeek,
                templateSession: session
            )
        }
        
        PersistenceController.save(viewContext)
    }
    
}
