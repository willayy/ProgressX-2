//
//  TemplateWeek.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateWeek: HasOrderable, HasChildren, HasParent, IsChangePropogator {
    
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
    
    // Protocol implementation
    internal var children: [TemplateSession] {
        
        return (self.templateSessions!.allObjects as! [TemplateSession])
            .sorted(by: { $0.positionIndex < $1.positionIndex })
        
    }
    
    // Protocol implementation
    internal var parent: TemplateCycle {
        
        return self.templateCycle!
        
    }
    
    // Protocol implementation
    internal func getNextPositionIndex() -> Int64 {
        
        let sessions: [TemplateSession] = self.templateSessions?.allObjects as! [TemplateSession]
        
        let max = sessions.max { $0.positionIndex < $1.positionIndex }
        
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    public func getPositionIndexes() -> [Int64] {
        
        let children = self.templateSessions!.allObjects as! [TemplateSession]
        
        let positionIndexes = children.map { $0.positionIndex }
        
        return positionIndexes.sorted()
    }
    
    // Protocol implementation
    public func propogateChanges() -> Void {
        
        let trainingWeeks = self.trainingWeeks?.allObjects as! [TrainingWeek]
        
        let changes = self.changedValues()
        
        // There should only be one active week with self as its templateWeek
        for trainingWeek in trainingWeeks {
            
            if let timePeriodName = changes["timePeriodName"] {
                
                trainingWeek.timePeriodName = timePeriodName as? String
                
            }
            
            if let timePeriodDescription = changes["timePeriodDescription"] {
                
                trainingWeek.timePeriodDescription = timePeriodDescription as? String
                
            }
            
            if let positionIndex = changes["positionIndex"] {
                
                trainingWeek.switchPositionIndex(to: positionIndex as! Int64)
                
            }
            
        }
    }
    
    // MARK: Extra Properties
    
    // No Extra properties on this class extension.
    
    // MARK: Validation
    
    // No extra validation on this class extension.
    
}
