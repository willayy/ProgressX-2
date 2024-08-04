//
//  AddingViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-02.
//

import Foundation
import CoreData

protocol AddingViewModel {
    
    func saveEntry(viewContext: NSManagedObjectContext)
    
}
