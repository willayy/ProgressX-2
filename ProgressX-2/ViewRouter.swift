//
//  ViewRouter.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

class ViewRouter: ObservableObject {
    @Published var rootView: String = (DataUtility.doesProfileExist()) ? "HomeView" : "CreateNewProfile1"
}
