//
//  EditTemplateSessionViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditTemplateSessionViewModel: ViewModel, EditingViewModel {
    
    @Published public var showSessionChangedAlert: Bool = false
    
    @Published public var showNoChangeAlert: Bool = false
    
    @Published public var editedSessionName: String = ""
    
    @Published public var editedSessionDescription: String = ""
    
    @Published public var editedPositionIndex: Int64 = 0
    
    typealias T = TemplateSession
    
    public func positionIndexes(selectedTemplateSession: TemplateSession) -> [Int64] {
        selectedTemplateSession.getPositionIndexes()
    }
    
    public func setViewStartValues(entity: TemplateSession) -> Void {
        editedSessionName = entity.timePeriodName!
        editedSessionDescription = entity.timePeriodDescription!
        editedPositionIndex = entity.positionIndex
    }
    
    public func saveEdits(entity: TemplateSession, viewContext: NSManagedObjectContext) -> Void {
        
        if entity.timePeriodName != editedSessionName {
            entity.timePeriodName = editedSessionName
        }
        
        if entity.timePeriodDescription != editedSessionDescription {
            entity.timePeriodDescription = editedSessionDescription
        }
        
        if entity.positionIndex != editedPositionIndex {
            entity.switchPositionIndex(to: editedPositionIndex)
        }
        
        if entity.hasChanges {
            
            // Propogate changes to matching TrainingSessions.
            entity.propogateChanges()
            
            withAnimation { showSessionChangedAlert = true }
            
            self.save(viewContext)
            
        } else {
            
            withAnimation { showNoChangeAlert = true }
            
        }
    }
}
