//
//  ViewRouter.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var rootView: String = (PersistenceController.shared.doesProfileExist()) ? "HomeView" : "CreateNewProfile1"
}
