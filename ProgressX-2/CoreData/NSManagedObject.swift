//
//  nsmoExtension.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-14.
//

import Foundation
import CoreData

extension NSManagedObject {
    
    /// Original NSManagedObject setValue function but now with chaining.
    /// - Parameters:
    ///   - _value:  A value to be inserted into the attribute.
    ///   - forKey: The matching key for the attribute you want to modify.
    /// - Returns: The NSManagedObject that was modified.
    public func setValue_ch(_ value: Any?, forKey: String) -> Self {
        self.setValue(value, forKey: forKey)
        return self
    }
}
