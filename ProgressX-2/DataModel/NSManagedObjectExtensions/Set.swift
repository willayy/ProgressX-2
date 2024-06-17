//
//  Set.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import Foundation

extension Set {
    
    /// Convience method for getting the name of the Exercise.
    /// - Returns: The name of the sets exercise as a String.
    @objc public func exerciseString() -> String? {
        guard let name = self.exercise!.exerciseName else {
            // Since CoreData does not allow me to make this relationship non-optional
            fatalError("No exercise set on this Set")
        }
        
        return name
    }
    
    /// Convenience method for getting the load todo on a Set.
    /// - Returns: The load todo as a formatted String.
    @objc public func loadTodoString() -> String {
        return String(format: "%.2f", self.loadTodo)
    }
    
    /// Convenience method for getting the quantity todo on a Set.
    /// - Returns: The quantity todo as a formatted String.
    @objc public func quantityTodoString() -> String {
        guard let type = self.exercise!.exerciseType else {
            // Since CoreData does not allow me to make this relationship non-optional
            fatalError("No exercise set on this Set")
        }
        
        switch type {
            case "reps":
                return String(format: "%.0f", self.quantityTodo)
            case "time":
                return String(format: "%.2f", self.quantityTodo)
            default:
                return ""
        }
    }
    
    /// Convenience method for getting the load done on a Set.
    /// - Returns: The load done as a formatted String.
    @objc public func loadDoneString() -> String {
        return String(format: "%.2f", self.loadDone)
    }
    
    /// Convenience method for getting the quantity done on a Set.
    /// - Returns: The quantity done as a formatted String.
    @objc public func quantityDoneString() -> String {
        guard let type = self.exercise!.exerciseType else {
            // Since CoreData does not allow me to make this relationship non-optional
            fatalError("No exercise set on this Set")
        }
        
        switch type {
            case "reps":
                return String(format: "%.0f", self.quantityDone)
            case "time":
                return String(format: "%.2f", self.quantityDone)
            default:
                return ""
        }
    }

}
