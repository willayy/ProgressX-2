//
//  ProgressX_2App.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI

@main
struct ProgressX_2App: App {

    let persistenceContainer = PersistenceController.shared.container
    @StateObject var viewRouter = ViewRouter()
    @State var isLoading: Bool = true
    
    var body: some Scene {
        WindowGroup {
            
            if isLoading {
                MockLaunchScreen()
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                isLoading = false
                            }
                        }
                    })
            }
            
            else {
                switch (viewRouter.rootView) {
                case "HomeView":
                    ExerciseLibraryView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case "CreateNewProfile1":
                    CreateNewProfile1()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case "ExerciseLibrary":
                    ExerciseLibraryView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                default:
                    fatalError("View router is in an invalid state")
                }
            }
        }
    }
}
