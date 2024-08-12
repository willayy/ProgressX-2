//
//  Orderable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-28.
//

import Foundation

extension OrderableTimePeriod {
    
    // MARK: Extra Properties
    
    // Nothing here
    
    // MARK: Validaiton
    
    override public func validateForUpdate() throws {
        try super.validateForUpdate()
        try revalidateParentChildRelationships()
    }
    
    
    /// Notifies the parent that it should evalidate its "parent" and "child" relationship when positionIndex changes in a child.
    private func revalidateParentChildRelationships() throws {
        let changedValues = changedValues()
        if changedValues.keys.contains("positionIndex") {
            switch self {
            case is TrainingCycle:
                try (self as! TrainingCycle).routine!.validateForUpdate()
            case is TrainingWeek:
                try (self as! TrainingWeek).trainingCycle!.validateForUpdate()
            case is TrainingSession:
                try (self as! TrainingSession).trainingWeek!.validateForUpdate()
            case is TrainingSet:
                try (self as! TrainingSet).trainingSession!.validateForUpdate()
            case is TemplateWeek:
                try (self as! TemplateWeek).templateCycle!.validateForUpdate()
            case is TemplateSession:
                try (self as! TemplateSession).templateWeek!.validateForUpdate()
            case is TemplateSet:
                try (self as! TemplateSet).templateSession!.validateForUpdate()
            case is SetThreshold:
                try (self as! SetThreshold).templateSet!.validateForUpdate()
            default:
                break
            }
        }
    }
    
    public func switchPositionIndex(to: Int64) -> Void {
        #warning("TODO: Implement, this should cause the parent to revalidate")
    }

}
