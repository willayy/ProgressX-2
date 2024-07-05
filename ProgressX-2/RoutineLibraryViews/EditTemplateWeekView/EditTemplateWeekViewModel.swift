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
    @Published var showChangeInfo: Bool = false
    @Published var editedWeekName: String = ""
    @Published var editedWeekIsInvalid: Bool = false
    @Published var editedWeekNameIsInvalidMsg: String = ""
    @Published var editedWeekDescription: String = ""
    @Published var editedWeekDescIsInvalid: Bool = false
    @Published var editedWeekDescIsInvalidMsg: String = ""
    @Published var editedPositionIndex: Int64 = 0
    
    // Get the positionIndexes for all weeks in this Routine
    public func positionIndexes(selectedTemplateWeek: TemplateWeek?) -> [Int64] {
        let cycle = selectedTemplateWeek!.templateCycle!
        let weeks = cycle.templateWeeks!.allObjects as! [TemplateWeek]
        let positionIndexes = weeks.map { week in
            week.positionIndex
        }
        return positionIndexes.sorted()
    }
    
    public func changeTemplateWeekInfo(viewContext: NSManagedObjectContext, selectedTemplateWeek: TemplateWeek?) -> Void {
        let inputName = editedWeekName.isEmpty ? selectedTemplateWeek!.timePeriodName! : editedWeekName
        let inputDesc = editedWeekDescription.isEmpty ? selectedTemplateWeek!.timePeriodDescription! : editedWeekDescription
        
        // Find the week with the same position index in the parent routine
        let weeksInParentRoutine = selectedTemplateWeek!.templateCycle!.templateWeeks!.allObjects as! [TemplateWeek]
        let switchWithWeek = weeksInParentRoutine.first(
            where: {
                ($0 as AnyObject).positionIndex == editedPositionIndex
            }
        )
        
        let positionIndexDidChange: Bool = (editedPositionIndex != selectedTemplateWeek!.positionIndex)
        
        // Switch position index with the week
        switchWithWeek!.positionIndex = selectedTemplateWeek!.positionIndex
        
        selectedTemplateWeek!.positionIndex = editedPositionIndex
        selectedTemplateWeek!.timePeriodName = inputName
        selectedTemplateWeek!.timePeriodDescription = inputDesc
        
        PersistenceController.save(viewContext)
        
        // Show alert if stuff changes
        withAnimation(.easeOut) {
            if editedWeekName.isEmpty && editedWeekDescription.isEmpty && !positionIndexDidChange {
                showNoChangeAlert = true
            } else {
                showWeekChangedAlert = true
            }
            editedWeekName = ""
            editedWeekDescription = ""
        }
    }
    
    public func addSession(viewContext: NSManagedObjectContext, selectedTemplateWeek: TemplateWeek?) -> Void {
        let positionIndex = selectedTemplateWeek!.getNextPositionIndex()
        _ = PersistenceController.createTemplateSession(
            viewContext,
            name: "Session \(positionIndex)",
            templateWeek: selectedTemplateWeek!,
            positionIndex: positionIndex
        )
        PersistenceController.save(viewContext)
    }
    
}
