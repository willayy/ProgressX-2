//
//  SavingViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-08-01.
//

import Foundation
import CoreData
import SwiftUI

class SavingViewModel: ObservableObject {
    
    @Published public var savingError: Bool = false
    
    public func safeSave(viewContext: NSManagedObjectContext) -> Void {
        do {
            try PersistenceController.save_t(viewContext)
        } catch {
            withAnimation {
                savingError = true
            }
        }
    }
    
}
