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
    @Published var rootView: String = (DataFetching.doesProfileExist(context)) ? "HomeView" : "CreateNewProfile1"
}
