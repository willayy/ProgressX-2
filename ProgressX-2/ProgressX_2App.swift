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
    @StateObject var viewRouter = ViewRouter()
    
    var body: some Scene {
        WindowGroup {
            switch (viewRouter.rootView) {
                case "HomeView":
                    ExerciseLibrary()
                        .environmentObject(viewRouter)
                case "CreateNewProfile1":
                    CreateNewProfile1()
                        .environmentObject(viewRouter)
            default:
                fatalError("View router invalid state")
            }
        }
    }
}
