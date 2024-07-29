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
                
            } else {
                
                SideBarView() {
                    switch (viewRouter.rootView) {
                        case .HomeView:
                            HomeView()
                            
                        case .StartWorkoutView:
                            StartWorkoutView()
                            
                        case .ExerciseLibraryView:
                            ExerciseLibraryView()
                            
                        case .ProfileView:
                            ProfileView()
                            
                        case .RoutineLibraryView:
                            RoutineLibraryView()
                            
                        case .InfoHelp:
                            InfoHelpView()
                        
                        case .CreateNewProfileView:
                            CreateNewProfile1View()
                    }
                }
                .environmentObject(viewRouter)
                .environment(\.managedObjectContext, persistenceContainer.viewContext)
            }
        }
    }
}
