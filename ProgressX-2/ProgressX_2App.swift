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
            }else {
                switch (viewRouter.rootView) {
                case .HomeView:
                    HomeView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case .StartWorkoutView:
                    StartWorkoutView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case .CreateNewProfileView:
                    CreateNewProfile1View()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case .ExerciseLibraryView:
                    ExerciseLibraryView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case .ProfileView:
                    ProfileView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case .SideBarButton:
                    SideBarButton(showMenu: $showMenu)
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                case .RoutineLibraryView:
                    RoutineLibraryView()
                        .environmentObject(viewRouter)
                        .environment(\.managedObjectContext, persistenceContainer.viewContext)
                }
            }
        }
    }
}
