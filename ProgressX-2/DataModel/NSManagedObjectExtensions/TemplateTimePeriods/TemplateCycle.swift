//
//  TemplateCycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateCycle: HasOrderable {
    
    // MARK: Convenience init
    
    convenience init(
        _ context: NSManagedObjectContext,
        routine: Routine,
        name: String = "",
        description: String = ""
    ) {
        self.init(context: context)
        self.routine = routine
        let routineName = routine.timePeriodName!
        self.timePeriodName = (name == "") ? "\(routineName)-templateCycle" : name
        self.timePeriodDescription = (description == "") ? "templateCycle created for: \(routineName)" : description
        routine.templateCycle = self
    }

    // MARK: Extra properties
    
    func getNextPositionIndex() -> Int64 {
        let weeks: [TemplateWeek] = self.templateWeeks?.allObjects as! [TemplateWeek]
        let max = weeks.max {$0.positionIndex < $1.positionIndex}
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
        let weeks: [TemplateWeek] = self.templateWeeks?.allObjects as! [TemplateWeek]
        let groupedBy = Dictionary(grouping: weeks, by: {$0.positionIndex})
        let duplicates = groupedBy.filter { $1.count > 1 }
        if !duplicates.isEmpty { throw ValidationNSErrors.positionIndexIsInvalid.toNSError()}
    }
}
