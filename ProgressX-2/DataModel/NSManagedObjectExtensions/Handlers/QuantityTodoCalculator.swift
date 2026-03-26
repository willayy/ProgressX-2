//
//  QuantityTodoCalculator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-29.
//

import Foundation

internal class QuantityTodoCalculator {
    
    private let templateSet: TemplateSet
    
    init(templateSet: TemplateSet) {
        
        self.templateSet = templateSet
        
    }
    
    internal func getQuantityTodo() -> Double {
        
        let context = templateSet.managedObjectContext!
        
        let quantityTypeEnum = QuantityType(rawValue: self.templateSet.quantityType!)!
        
        switch quantityTypeEnum {
            
            case .numerical:
                
                return templateSet.setQuantity
                
            case .maxPercentage:
                
                let exercise = templateSet.exercise!
                
                let prType = exercise.exerciseType == ExerciseType.Reps.rawValue ? PersonalRecordType.MaxReps.rawValue : PersonalRecordType.TimeMax.rawValue
                
                let latestPr = CoreDataAccess.getLatestPersonalRecord(context, exercise: exercise, prType: prType)
                
                var computedQuantity: Double = (latestPr?.prQuantity ?? 0) * (templateSet.setQuantity / 100)
                
                if exercise.exerciseType! == ExerciseType.Reps.rawValue { computedQuantity = floor(computedQuantity) }
                
                return computedQuantity
        }
        
    }
    
}
