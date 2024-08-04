//
//  EditingViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData

protocol EditingViewModel {
    
    associatedtype T
    
    func saveEdits(entity: T, viewContext: NSManagedObjectContext)
    
}
