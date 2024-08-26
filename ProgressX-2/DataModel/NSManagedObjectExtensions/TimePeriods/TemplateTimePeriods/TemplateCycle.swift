//
//  TemplateCycle.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateCycle: HasOrderable, HasChildren, HasParent {
    
    // MARK: Convenience init
    
    public convenience init(
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
    
    /// Initializer for a TemplateCycle using JSON data
    public convenience init(
        _ context: NSManagedObjectContext,
        routine: Routine,
        json: [String : Any]
    ) {
        self.init(context: context)
        self.routine = routine
        routine.templateCycle = self
        self.timePeriodName = (json["timePeriodName"] as! String)
        self.timePeriodDescription = (json["timePeriodDescription"] as! String)
    }
    
    // MARK: Protocol implementation
    
    internal typealias ChildrenType = TemplateWeek
    
    internal typealias ParentType = Routine
    
    // Protocol implementation
    internal var children: [TemplateWeek] {
        return self.templateWeeks!.allObjects as! [TemplateWeek]
    }
    
    // Protocol implementation
    internal var parent: Routine {
        return self.routine!
    }
    
    // Protocol implementation
    internal func getNextPositionIndex() -> Int64 {
        let weeks: [TemplateWeek] = self.templateWeeks?.allObjects as! [TemplateWeek]
        let max = weeks.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    internal func getPositionIndexes() -> [Int64] {
        let children = self.templateWeeks!.allObjects as! [TemplateWeek]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }

    // MARK: Extra properties
    
    // No extra properties on this class extension.
    
    // MARK: Validation
    
    // No extra validation on this class extension.
    
}
