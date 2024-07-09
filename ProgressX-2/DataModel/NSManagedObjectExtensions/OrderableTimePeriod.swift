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
        // If the positionIndex is changed tell a related object to revalidate
        let changedValues = changedValues()
        if changedValues.keys.contains("positionIndex") {
            try revalidateRelationShip()
        }
    }
    
    // Revalidates "parent" relationship
    private func revalidateRelationShip() throws {
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
