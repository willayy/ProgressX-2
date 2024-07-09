//
//  TemplateCycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation

extension TemplateCycle: HasOrderable {
    
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
        if !duplicates.isEmpty { throw ValidationNSErrors.invalidPositionIndex.toNSError()}
    }
}
