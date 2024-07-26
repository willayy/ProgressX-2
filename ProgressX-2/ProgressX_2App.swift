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
    @State var showMenu: Bool = false
    
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
                
            } else {
                
                SideBarView(showMenu: $showMenu) {
                    switch (viewRouter.rootView) {
                        case .HomeView:
                            HomeView()
                                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                            
                        case .StartWorkoutView:
                            StartWorkoutView()
                            
                        case .ExerciseLibraryView:
                            ExerciseLibraryView()
                                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                            
                        case .ProfileView:
                            ProfileView()
                                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                            
                        case .RoutineLibraryView:
                            RoutineLibraryView()
                                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                            
                        case .InfoHelp:
                            InfoHelpView()
                        
                        case .CreateNewProfileView:
                            CreateNewProfile1View()
                                .environmentObject(viewRouter)
                                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                    }
                }
                .environmentObject(viewRouter)
            }
        }
    }
}
