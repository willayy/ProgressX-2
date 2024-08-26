//
//  TemplateWeek.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateWeek: HasOrderable, HasChildren, HasParent {
    
    //MARK: Convenience init
    
    public convenience init(
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
    
    /// Initializer for a TemplateWeek using JSON data
    public convenience init(
        _ context: NSManagedObjectContext,
        templateCycle: TemplateCycle,
        json: [String : Any]
    ) {
        self.init(context: context)
        self.templateCycle = templateCycle
        templateCycle.addToTemplateWeeks(self)
        self.positionIndex = templateCycle.getNextPositionIndex()
        self.timePeriodName = (json["timePeriodName"] as! String)
        self.timePeriodDescription = (json["timePeriodDescription"] as! String)
    }
    
    // MARK: Protocol implementation
    
    internal typealias ChildrenType = TemplateSession
    
    internal typealias ParentType = TemplateCycle
    
    // Protocol implementation
    internal var children: [TemplateSession] {
        return self.templateSessions!.allObjects as! [TemplateSession]
    }
    
    // Protocol implementation
    internal var parent: TemplateCycle {
        return self.templateCycle!
    }
    
    // Protocol implementation
    internal func getNextPositionIndex() -> Int64 {
        let sessions: [TemplateSession] = self.templateSessions?.allObjects as! [TemplateSession]
        let max = sessions.max {$0.positionIndex < $1.positionIndex}
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    internal func getPositionIndexes() -> [Int64] {
        let children = self.templateSessions!.allObjects as! [TemplateSession]
        let positionIndexes = children.map { $0.positionIndex }
        return positionIndexes
    }
    
    // MARK: Extra Properties
    
    // No Extra properties on this class extension.
    
    // MARK: Validation
    
    // No extra validation on this class extension.
    
}
