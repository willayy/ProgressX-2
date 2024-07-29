//
//  ViewRouter.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI
import CoreData

enum Route: String {
    case CreateNewProfileView = "CreateNewProfile1"
    case StartWorkoutView = "StartWorkoutView"
    case HomeView = "HomeView"
    case ExerciseLibraryView = "ExerciseLibraryView"
    case ProfileView = "ProfileView"
    case RoutineLibraryView = "RoutineLibraryView"
    case InfoHelp = "InfoHelp"
}

class ViewRouter: ObservableObject {
    static let context: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    static let profileExists: Bool = PersistenceController.profileExists(context)
    // Set the basic rootView on app start, if a profile doesnt exist always rout to CreateNewProfile view
    @Published var rootView: Route = (profileExists) ? Route.HomeView : Route.CreateNewProfileView
}
