//
//  EditTemplateWeek_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class EditTemplateWeekViewModel: ViewModel, EditingViewModel, AddingViewModel, DefaultValueViewModel {
    
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
        return selectedTemplateWeek.getPositionIndexes()
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
            
            entity.switchPositionIndex(to: editedPositionIndex)
            
        }
        
        if entity.hasChanges {
            
            // propogates change to matching trainingWeeks.
            entity.propogateChanges()
            
            withAnimation {
                
                showWeekChangedAlert = true
                
            }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation {
                
                showNoChangeAlert = true
                
            }
            
        }
    }
    
    /// Adds a session to the template and all incomplete matching TrainingWeeks
    public func saveEntry(viewContext: NSManagedObjectContext) -> Void {
        
        let session = TemplateSession(
            viewContext,
            templateWeek: selectedTemplateWeek!
        )
        
        // Only included incomplete trainingWeeks as completed ones are irrelevant for this change
        let trainingWeeks = selectedTemplateWeek!.trainingWeeks?.allObjects as! [TrainingWeek]
        
        for trainingWeek in trainingWeeks {
            
            let _ = TrainingSession(
                viewContext,
                trainingWeek: trainingWeek,
                templateSession: session
            )
            
        }
        
        self.save(viewContext)
    }
    
}
