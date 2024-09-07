//
//  ViewRouter.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

enum StartRoute: String {
    case CreateNewProfileView = "CreateNewProfile1"
    case None = "None"
}

enum Route: String {
    case StartWorkoutView = "StartWorkoutView"
    case HomeView = "HomeView"
    case ExerciseLibraryView = "ExerciseLibraryView"
    case ProfileView = "ProfileView"
    case RoutineLibraryView = "RoutineLibraryView"
    case InfoHelp = "InfoHelp"
    case ChooseWeekHistoryView = "ChooseWeekHistoryView"
}

class ViewRouter: ObservableObject {
    // Set the basic rootView on app start, if a profile doesnt exist always rout to CreateNewProfile view
    @Published public var startView: StartRoute = .None
    @Published public var rootView: Route = .HomeView
}
