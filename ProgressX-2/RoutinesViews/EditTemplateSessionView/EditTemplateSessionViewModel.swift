//
//  EditTemplateSessionViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-05.
//

import Foundation
import CoreData
import SwiftUI

class EditTemplateSessionViewModel: ObservableObject {
    
    @Published var showSessionChangedAlert: Bool = false
    @Published var showNoChangeAlert: Bool = false
    @Published var editedSessionName: String = ""
    @Published var editedSessionIsInvalid: Bool = false
    @Published var editedSessionNameIsInvalidMsg: String = ""
    @Published var editedSessionDescription: String = ""
    @Published var editedSessionDescIsInvalid: Bool = false
    @Published var editedSessionDescIsInvalidMsg: String = ""
    @Published var editedPositionIndex: Int64 = 0
    
    public func positionIndexes(selectedTemplateSession: TemplateSession) -> [Int64] {
        let week = selectedTemplateSession.templateWeek!
        let sessions = week.templateSessions!.allObjects as! [TemplateSession]
        let positionIndexes = sessions.map { session in
            session.positionIndex
        }
        return positionIndexes.sorted()
    }
    
    public func setViewStartValues(selectedTemplateSession: TemplateSession?) -> Void {
        editedSessionName = selectedTemplateSession!.timePeriodName!
        editedSessionDescription = selectedTemplateSession!.timePeriodDescription!
        editedPositionIndex = selectedTemplateSession!.positionIndex
    }
    
    public func saveTemplateSessionChanges(viewContext: NSManagedObjectContext, selectedTemplateSession: TemplateSession) -> Void {
        
        if selectedTemplateSession.timePeriodName != editedSessionName {
            selectedTemplateSession.timePeriodName = editedSessionName
        }
        
        if selectedTemplateSession.timePeriodDescription != editedSessionDescription {
            selectedTemplateSession.timePeriodDescription = editedSessionDescription
        }
        
        if selectedTemplateSession.positionIndex != editedPositionIndex {
            selectedTemplateSession.positionIndex = editedPositionIndex
        }
        
        if selectedTemplateSession.hasChanges {
            // Propogate changes to matching TrainingSessions.
            propogateChanges(viewContext, selectedTemplateSession: selectedTemplateSession)
            
            withAnimation {
                showSessionChangedAlert = true
                PersistenceController.save(viewContext)
            }
        } else {
            withAnimation {
                showNoChangeAlert = true
            }
        }
    }
    
    /// Propogating changes made to the TemplateSession to all matching TrainingSession.
    private func propogateChanges(_ viewContext: NSManagedObjectContext, selectedTemplateSession: TemplateSession) -> Void {
        let changes = selectedTemplateSession.changedValues() // Get changes
        let fetchRequest: NSFetchRequest<TrainingSession> = TrainingSession.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "templateSession == %@", selectedTemplateSession)
        
        // Fetch all incomplete sessions as these are the only ones affected
        let trainingSessions = PersistenceController.fetch(viewContext, fetchRequest: fetchRequest)
            .filter({!$0.isComplete})
        
        for trainingSesison in trainingSessions {
            if let timePeriodName = changes["timePeriodName"] {
                trainingSesison.timePeriodName = (timePeriodName as! String)
            }
            
            if let timePeriodDesc = changes["timePeriodDescription"] {
                trainingSesison.timePeriodName = timePeriodDesc as? String
            }
            
            if let positionIndex = changes["positionIndex"] {
                trainingSesison.positionIndex = positionIndex as! Int64
            }
        }
    }
    
}
