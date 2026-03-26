//
//  EditTemplateWeek_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import SwiftUI
import CoreData

class EditTemplateWeekViewModel: ViewModel {
    
    @Published public var showWeekChangedAlert: Bool = false
    
    @Published public var showNoChangeAlert: Bool = false
    
    @Published public var editedWeekName: String = ""
    
    @Published public var editedWeekDescription: String = ""
    
    @Published public var editedPositionIndex: Int64 = 0
    
    @Published public var selectedTemplateWeek: TemplateWeek? = nil
        
    /// Get the positionIndexes for all weeks in this Routine
    public func positionIndexes(selectedTemplateWeek: TemplateWeek) -> [Int64] {
        return selectedTemplateWeek.getPositionIndexes()
    }
    
    public func setViewStartValues(entity: TemplateWeek) {
        self.editedWeekName = entity.timePeriodName!
        self.editedWeekDescription = entity.timePeriodDescription!
        self.editedPositionIndex = entity.positionIndex
    }
    
    /// Saves changes made to template and propogates them forwars to all matching TrainingSessions.
    public func saveEdits(entity: TemplateWeek, viewContext: NSManagedObjectContext) -> Void {
        
        if entity.timePeriodName != self.editedWeekName {
            
            entity.timePeriodName = self.editedWeekName
            
        }
        
        if entity.timePeriodDescription != self.editedWeekDescription {
            
            entity.timePeriodDescription = self.editedWeekDescription
            
        }
        
        if entity.positionIndex != self.editedPositionIndex {
            
            entity.switchPositionIndex(to: self.editedPositionIndex)
            
        }
        
        if entity.hasChanges {
            
            // propogates change to matching trainingWeeks.
            entity.propogateChanges()
            
            withAnimation {
                
                self.showWeekChangedAlert = true
                
            }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation {
                
                self.showNoChangeAlert = true
                
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
