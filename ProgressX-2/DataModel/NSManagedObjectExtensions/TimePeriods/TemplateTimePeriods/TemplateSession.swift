//
//  TemplateSession.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation
import CoreData

extension TemplateSession: HasOrderable, HasChildren, HasParent, IsChangePropogator {
    
    //MARK: Convenience init
    
    public convenience init(
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
    
    /// Initializer for a TemplateSession using JSON data
    public convenience init(
        _ context: NSManagedObjectContext,
        templateWeek: TemplateWeek,
        json: [String : Any]
    ) {
        self.init(context: context)
        self.templateWeek = templateWeek
        templateWeek.addToTemplateSessions(self)
        self.positionIndex = templateWeek.getNextPositionIndex()
        self.timePeriodName = (json["timePeriodName"] as! String)
        self.timePeriodDescription = (json["timePeriodDescription"] as! String)
    }
    
    // MARK: Protocol implementation
    
    // Protocol implementation
    internal var children: [TemplateSet] {
        
        return self.templateSets!.allObjects as! [TemplateSet]
        
    }
    
    // Protocol implementation
    internal var parent: TemplateWeek {
        
        return self.templateWeek!
        
    }
    
    // Protocol implementation
    internal func getNextPositionIndex() -> Int64 {
        
        let sets: [TemplateSet] = self.templateSets?.allObjects as! [TemplateSet]
        
        let max = sets.max {$0.positionIndex < $1.positionIndex}
        
        return Int64((max?.positionIndex ?? 0) + 1)
    }
    
    // Protocol implementation
    public func getPositionIndexes() -> [Int64] {
        
        let children = self.templateSets!.allObjects as! [TemplateSet]
        
        let positionIndexes = children.map { $0.positionIndex }
        
        return positionIndexes.sorted()
    }
    
    // Protocol implementation
    public func propogateChanges() -> Void {
        
        let trainingSessions = self.trainingSessions?.allObjects as! [TrainingSession]
        
        let changes = self.changedValues()
        
        // There should only be one active week with self as its templateWeek
        for trainingSession in trainingSessions {
            
            if let timePeriodName = changes["timePeriodName"] {
                
                trainingSession.timePeriodName = timePeriodName as? String
                
            }
            
            if let timePeriodDescription = changes["timePeriodDescription"] {
                
                trainingSession.timePeriodDescription = timePeriodDescription as? String
                
            }
            
            if let positionIndex = changes["positionIndex"] {
                
                trainingSession.switchPositionIndex(to: positionIndex as! Int64)
                
            }
            
        }
    }
    
    // MARK: Extra Properties
    
    // No extra properties on this class extension
    
    // MARK: Validation
    
    // No extra validation on this class extension
    
}
