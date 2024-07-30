//
//  ProgressX_2App.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-12.
//

import SwiftUI
import CoreData

@main
struct ProgressX_2App: App {

    let persistenceContainer = PersistenceController.shared.container
    @StateObject var viewRouter = ViewRouter()
    @State var isLoading: Bool = true
    static let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    static let profileExists: Bool = PersistenceController.profileExists(context)

    var body: some Scene {
        WindowGroup {            
            if isLoading {
                
                // Run the launch screen and the mock launch screen.
                MockLaunchScreen()
                    .onAppear(perform: {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            // When mock loading is done find the correct startView
                            withAnimation {
                                isLoading = false
                                viewRouter.startView = (ProgressX_2App.profileExists) ? .None : .CreateNewProfileView
                            }
                        }
                    })
                
            } else if viewRouter.startView == .CreateNewProfileView {
                
                // If no profile exists launch createProfileViews.
                CreateNewProfile1View()
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                .zIndex(1)
                .environmentObject(viewRouter)
                .environment(\.managedObjectContext, persistenceContainer.viewContext)
                
            } else {
                
                // Else launch the standard app view hierarchy.
                SideBarView() {
                    
                    switch (viewRouter.rootView) {
                        case .HomeView:
                            HomeView()
                            
                        case .StartWorkoutView:
                            fatalError("CHECK ProgressX_2App and you will understand")
                            // StartWorkoutView()
                            //    .environmentObject(viewRouter)
                            //    .environment(\.managedObjectContext, persistenceContainer.viewContext)
                            
                        case .ExerciseLibraryView:
                            ExerciseLibraryView()
                            
                        case .ProfileView:
                            ProfileView()
                            
                        case .RoutineLibraryView:
                            RoutineLibraryView()
                            
                        case .InfoHelp:
                            InfoHelpView()
                    }
                }
                .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.5)))
                .zIndex(1)
                .environmentObject(viewRouter)
                .environment(\.managedObjectContext, persistenceContainer.viewContext)
            }
        }
    }
}
