//
//  SideBarEnums.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-29.
//

import Foundation

enum Tab: String, CaseIterable {
    case Home = "house.fill"
    case StartWorkout = "figure.run"
    case Routines = "rectangle.stack"
    case Exercises = "dumbbell"
    case InfoHelp = "questionmark.circle"
    case Profile = "person.crop.circle"
    
    var title: String {
        switch self {
        case .Home: return "Home"
        case .StartWorkout: return "Start workout"
        case .Routines: return "Routines"
        case .Exercises: return "Exercises"
        case .Profile: return "Profile"
        case .InfoHelp: return "Info / Help"
        }
    }
}
