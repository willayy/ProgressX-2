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
    
    @Environment(\.managedObjectContext) private var viewContext
    
    public var weightUnit: String {
        return PersistenceController.getWeightUnit(viewContext)!
    }
    
    public var lengthUnit: String {
        return PersistenceController.getLengthUnit(viewContext)!
    }
    
}
