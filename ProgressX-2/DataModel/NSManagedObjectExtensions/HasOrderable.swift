//
//  HasOrderable.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-27.
//

import Foundation

// Protocol used for Entites that has Orderables in a one-to-many relationship
protocol HasOrderable {
    
    // If object has this protocol it needs to implement this function to get the correct next position index.
    func getNextPositionIndex() -> Int64

}
