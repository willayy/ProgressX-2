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
    
    // Revalidates "parent" and "child" relationship when positionIndex changes
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
            default:
                break
            }
        }
    }

}
