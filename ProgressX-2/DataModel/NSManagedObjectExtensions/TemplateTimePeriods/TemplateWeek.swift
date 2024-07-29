//
//  TemplateWeek.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateWeek: HasOrderable {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        templateCycle: TemplateCycle,
        name: String = "",
        description: String = ""
    ) {
        self.init(context: context)
        self.templateCycle = templateCycle
        let positionIndex = templateCycle.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "Week \(positionIndex)" : name
        let routineName = templateCycle.routine!.timePeriodName!
        self.timePeriodDescription = (description == "") ? "Week in \(routineName)" : description
        templateCycle.addToTemplateWeeks(self)
    }
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sessions: [TemplateSession] = self.templateSessions?.allObjects as! [TemplateSession]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // MARK: Validation
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validatePositionIndexes()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validatePositionIndexes()
    }
    
    // Validate that children has valid positionIndexes (No duplicates)
    private func validatePositionIndexes() throws {
        let sessions: [TemplateSession] = self.templateSessions?.allObjects as! [TemplateSession]
        let groupedBy = Dictionary(grouping: sessions, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
}
