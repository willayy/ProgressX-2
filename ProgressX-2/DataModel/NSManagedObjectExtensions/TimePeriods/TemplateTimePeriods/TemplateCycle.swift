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
    
    // Protocol implementation
    public func getNextPositionIndex() -> Int64 {
        let weeks: [TemplateWeek] = self.templateWeeks?.allObjects as! [TemplateWeek]
        let max = weeks.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    func getPositionIndexes() -> [Int64] {
        let children = self.templateWeeks!.allObjects as! [TemplateWeek]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // MARK: Validation
    
    // No extra validation on this class extension
    
}
