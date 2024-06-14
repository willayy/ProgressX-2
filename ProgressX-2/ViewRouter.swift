//
//  ViewRouter.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI
import CoreData

class ViewRouter: ObservableObject {
    static let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    static let profileExists: Bool = PersistenceController.profileExists(context)
    // Set the basic rootView on app start
    @Published var rootView: String = (profileExists) ? "HomeView" : "CreateNewProfile1"
}
