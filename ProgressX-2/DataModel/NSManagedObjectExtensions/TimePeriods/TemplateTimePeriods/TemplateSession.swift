//
//  TemplateSession.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateSession: HasOrderable {
    
    //MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        templateWeek: TemplateWeek,
        name: String = "",
        description: String = ""
    ) {
        self.init(context: context)
        self.templateWeek = templateWeek
        let positionIndex = templateWeek.getNextPositionIndex()
        self.positionIndex = positionIndex
        self.timePeriodName = (name == "") ? "Session \(positionIndex)" : name
        let weekName = templateWeek.timePeriodName!
        self.timePeriodDescription = (description == "") ? "Session in \(weekName)" : description
        templateWeek.addToTemplateSessions(self)
    }
    
    // MARK: Extra Properties
    
    public func getNextPositionIndex() -> Int64 {
        let sets: [TemplateSet] = self.templateSets?.allObjects as! [TemplateSet]
        let max = sets.max {$0.positionIndex < $1.positionIndex}
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
        let sets: [TemplateSet] = self.templateSets?.allObjects as! [TemplateSet]
        let groupedBy = Dictionary(grouping: sets, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty {
            throw ValidationNSErrors.positionIndexIsInvalid.toNSError()
        }
    }
    
}
