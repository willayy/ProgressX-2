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
        
    public func weightUnit(_ context: NSManagedObjectContext) -> String {
        return CoreDataAccess.getWeightUnit(context) ?? ""
    }
    
    public func lengthUnit(_ context: NSManagedObjectContext) -> String {
        return CoreDataAccess.getLengthUnit(context) ?? ""
    }
    
    public func save(_ context: NSManagedObjectContext) -> Void {
        CoreDataAccess.save(context)
    }
    
}
