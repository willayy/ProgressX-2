//
//  EditTemplateSessionViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditTemplateSessionViewModel: ViewModel {
    
    @Published public var showSessionChangedAlert: Bool = false
    
    @Published public var showNoChangeAlert: Bool = false
    
    @Published public var editedSessionName: String = ""
    
    @Published public var editedSessionDescription: String = ""
    
    @Published public var editedPositionIndex: Int64 = 0
        
    public func positionIndexes(selectedTemplateSession: TemplateSession) -> [Int64] {
        selectedTemplateSession.getPositionIndexes()
    }
    
    public func setViewStartValues(entity: TemplateSession) -> Void {
        self.editedSessionName = entity.timePeriodName!
        self.editedSessionDescription = entity.timePeriodDescription!
        self.editedPositionIndex = entity.positionIndex
    }
    
    public func saveEdits(entity: TemplateSession, viewContext: NSManagedObjectContext) -> Void {
        
        if entity.timePeriodName != self.editedSessionName {
            entity.timePeriodName = self.editedSessionName
        }
        
        if entity.timePeriodDescription != self.editedSessionDescription {
            entity.timePeriodDescription = self.editedSessionDescription
        }
        
        if entity.positionIndex != self.editedPositionIndex {
            entity.switchPositionIndex(to: self.editedPositionIndex)
        }
        
        if entity.hasChanges {
            
            // Propogate changes to matching TrainingSessions.
            entity.propogateChanges()
            
            withAnimation { self.showSessionChangedAlert = true }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation { self.showNoChangeAlert = true }
            
        }
    }
}
