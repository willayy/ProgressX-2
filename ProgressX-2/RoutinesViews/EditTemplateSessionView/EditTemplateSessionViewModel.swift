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
    @Published public var editedSessionIsInvalid: Bool = false
    @Published public var editedSessionNameIsInvalidMsg: String = ""
    @Published public var editedSessionDescription: String = ""
    @Published public var editedSessionDescIsInvalid: Bool = false
    @Published public var editedSessionDescIsInvalidMsg: String = ""
    @Published public var editedPositionIndex: Int64 = 0
    
    typealias T = TemplateSession
    
    public func positionIndexes(selectedTemplateSession: TemplateSession) -> [Int64] {
        let week = selectedTemplateSession.templateWeek!
        let sessions = week.templateSessions!.allObjects as! [TemplateSession]
        let positionIndexes = sessions.map { session in
            session.positionIndex
        }
        return positionIndexes.sorted()
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
            // Find the session with the same position index in the parent routine.
            let sessionInParentWeek = entity.templateWeek!.templateSessions!.allObjects as! [TemplateSession]
            let switchWithSession = sessionInParentWeek.first(
                where: {
                    $0.positionIndex == editedPositionIndex
                }
            )
            // Switch position index with the session
            switchWithSession!.positionIndex = entity.positionIndex
            entity.positionIndex = editedPositionIndex
        }
        
        if entity.hasChanges {
            // Propogate changes to matching TrainingSessions.
            propogateChanges(viewContext, selectedTemplateSession: entity)
            withAnimation { showSessionChangedAlert = true }
            self.save(viewContext)
        } else {
            withAnimation { showNoChangeAlert = true }
        }
    }
    
    /// Propogating changes made to the TemplateSession to all matching TrainingSession.
    private func propogateChanges(_ viewContext: NSManagedObjectContext, selectedTemplateSession: TemplateSession) -> Void {
        let changes = selectedTemplateSession.changedValues() // Get changes
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateSession == %@", selectedTemplateSession)
        
        // Fetch all incomplete sessions as these are the only ones affected
        let trainingSessions = CoreDataAccess.fetch(viewContext, fetchRequest: fetchRequest)
            .filter({!$0.isComplete})
        
        for trainingSession in trainingSessions {
            if let timePeriodName = changes["timePeriodName"] {
                trainingSession.timePeriodName = (timePeriodName as! String)
            }
            
            if let timePeriodDesc = changes["timePeriodDescription"] {
                trainingSession.timePeriodName = timePeriodDesc as? String
            }
            
            if let positionIndex = changes["positionIndex"] {
                // Find the session with the same position index in the parent routine.
                let sessionInParentWeek = trainingSession.trainingWeek!.trainingSessions!.allObjects as! [TrainingSession]
                let switchWithSession = sessionInParentWeek.first(
                    where: {
                        $0.positionIndex == positionIndex as! Int64
                    }
                )
                // Switch position index with the session
                switchWithSession!.positionIndex = trainingSession.positionIndex
                trainingSession.positionIndex = positionIndex as! Int64
            }
        }
    }
    
}
