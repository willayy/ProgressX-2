//
//  HasCompleteable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-05.
//

import Foundation

/// Protocol for entities that have children in a one-to-many relationship. This protocol is intended to be used with CompleteableTimePeriods.
protocol HasCompleteable {
    
    /// Checks if all the CompletableTimePeriod children in a Timeperiods one-to-many relationship are completed.
    func childrenAreComplete() -> Bool
    
    /// Returns true if all the object has any completeable children, false otherwise
    func hasCompleteableChildren() -> Bool
    
}
