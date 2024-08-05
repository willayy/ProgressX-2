//
//  ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-04.
//

import Foundation
import CoreData
import SwiftUI

class ViewModel: ObservableObject {
    
    // @Environment(\.managedObjectContext) private var viewContext
    
    public func weightUnit(_ context: NSManagedObjectContext) -> String {
        return PersistenceController.getWeightUnit(context)!
    }
    
    public func lengthUnit(_ context: NSManagedObjectContext) -> String {
        return PersistenceController.getLengthUnit(context)!
    }
    
}
