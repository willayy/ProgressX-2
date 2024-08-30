//
//  HasOrderable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-27.
//

import Foundation

/// Protocol used for Entites that has Orderables in a one-to-many relationship.
protocol HasOrderable {
    
    /// Gets the next positionIndex availible in the parent objects relationship containing Orderables.
    func getNextPositionIndex() -> Int64

    /// Gets all the positionIndexes of its children as a list.
    func getPositionIndexes() -> [Int64]
    
}
