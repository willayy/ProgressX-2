//
//  ProgressX_2App.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI

@main
struct ProgressX_2App: App {
    
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            if (persistenceController.doesProfileExist()) {
                HomeView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                CreateNewProfile1()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
