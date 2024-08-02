//
//  EditTemplateWeek_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class EditTemplateWeekViewModel: SavingViewModel, EditingViewModel, AddingViewModel, DefaultValueViewModel {
    
    @Published public var showWeekChangedAlert: Bool = false
    @Published public var showNoChangeAlert: Bool = false
    @Published public var editedWeekName: String = ""
    @Published public var editedWeekIsInvalid: Bool = false
    @Published public var editedWeekNameIsInvalidMsg: String = ""
    @Published public var editedWeekDescription: String = ""
    @Published public var editedWeekDescIsInvalid: Bool = false
    @Published public var editedWeekDescIsInvalidMsg: String = ""
    @Published public var editedPositionIndex: Int64 = 0
    @Published public var selectedTemplateWeek: TemplateWeek? = nil
    
    typealias T = TemplateWeek
    
    /// Get the positionIndexes for all weeks in this Routine
    public func positionIndexes(selectedTemplateWeek: TemplateWeek) -> [Int64] {
        let cycle = selectedTemplateWeek.templateCycle!
        let weeks = cycle.templateWeeks!.allObjects as! [TemplateWeek]
        let positionIndexes = weeks.map { week in
            week.positionIndex
        }
        return positionIndexes.sorted()
    }
    
    public func setViewStartValues(entity: TemplateWeek) {
        editedWeekName = entity.timePeriodName!
        editedWeekDescription = entity.timePeriodDescription!
        editedPositionIndex = entity.positionIndex
    }
    
    /// Saves changes made to template and propogates them forwars to all matching TrainingSessions.
    public func saveEdits(entity: TemplateWeek, viewContext: NSManagedObjectContext) -> Void {
        
        if entity.timePeriodName != editedWeekName {
            entity.timePeriodName = editedWeekName
        }
        
        if entity.timePeriodDescription != editedWeekDescription {
            entity.timePeriodDescription = editedWeekDescription
        }
        
        if entity.positionIndex != editedPositionIndex {
            // Find the week with the same position index in the parent routine.
            let weeksInParentRoutine = entity.templateCycle!.templateWeeks!.allObjects as! [TemplateWeek]
            let switchWithWeek = weeksInParentRoutine.first(
                where: {
                    ($0 as AnyObject).positionIndex == editedPositionIndex
                }
            )
            // Switch position index with the week
            switchWithWeek!.positionIndex = entity.positionIndex
            entity.positionIndex = editedPositionIndex
        }
        
        if entity.hasChanges {
            // propogates change to matching trainingWeeks.
            propogateChanges(viewContext, selectedTemplateWeek: entity)
            withAnimation { showWeekChangedAlert = true }
            self.safeSave(viewContext: viewContext)
        } else {
            withAnimation { showNoChangeAlert = true }
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
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        let session = TemplateSession(
            viewContext,
            templateWeek: selectedTemplateWeek!
        )
        
        // Get all trainingWeeks
        let fetchRequest: NSFetchRequest<TrainingWeek> = TrainingWeek.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateWeek == %@", selectedTemplateWeek!)
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
        
        self.safeSave(viewContext: viewContext)
    }
    
}
