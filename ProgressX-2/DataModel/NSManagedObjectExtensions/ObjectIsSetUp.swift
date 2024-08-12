//
//  ObjectIsSetUp.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-11.
//

import Foundation

#warning("TODO: Implement this where its needed")

/// Protocol for NSManagedObject subclasses that can be with the default initializer and therefore are partially set up according to constraints set on the DataModel.
protocol PartiallyInitializedObject {
    
    /// Checks if the objects is set up correctly according to the constraints of the DataModel.
    func objectIsSetUp() -> Bool
    
}
