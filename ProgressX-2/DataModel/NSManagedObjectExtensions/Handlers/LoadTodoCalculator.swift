//
//  LoadTodoCalculator.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-29.
//

import Foundation

internal class LoadTodoCalculator {
    
    private let templateSet: TemplateSet
    
    init(templateSet: TemplateSet) {
        self.templateSet = templateSet
    }
    
    internal func getLoadTodo() -> Double {
        
        let context = templateSet.managedObjectContext!
        
        let loadTypeEnum = LoadType(rawValue: templateSet.loadType!)!
        
        switch loadTypeEnum {
            
        case .numerical:
            
            return self.templateSet.setLoad
            
        case .maxPercentage:
            
            let exercise = templateSet.exercise!
            
            let prType = exercise.exerciseType == "reps" ? "onerepmax" : "timemax"
            
            let latestPr = CoreDataAccess.getLatestPersonalRecord(
                context,
                exercise: exercise,
                prType: prType
            )
            
            // Compute the percentage
            let computedLoad: Double = (latestPr?.weightLoad ?? 0) * (templateSet.setLoad / 100)
            
            // Round to smallest plate
            let profile = CoreDataAccess.getProfile(context)
            
            // times two because you always add two weights for balance
            let smallestPlate = profile!.smallestPlate * 2
            
            let roundedLoad: Double = (computedLoad / smallestPlate).rounded() * smallestPlate
            
            return roundedLoad
            
        case .bodyWeightPercentage:
            
            let latestBw = CoreDataAccess.getLatestBodyEntry(context)
            
            let computedLoad: Double = (latestBw?.bodyWeight ?? 0) * (templateSet.setLoad / 100)
            
            let profile = CoreDataAccess.getProfile(context)!
            
            // times two because you always add two weights for balance
            let smallestPlate = profile.smallestPlate * 2
            
            let roundedLoad: Double = (computedLoad / smallestPlate).rounded() * smallestPlate
            
            return roundedLoad
        }
    }
}
