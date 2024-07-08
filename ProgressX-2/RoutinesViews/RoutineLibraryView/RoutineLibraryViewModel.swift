//
//  RoutineLibraryView_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation

class RoutineLibraryViewModel: ObservableObject {
    
    @Published var selectedRoutine: Routine? = nil
    @Published var selectedTemplateCycle: TemplateCycle? = nil
    @Published var selectedTemplateWeek: TemplateWeek? = nil
    @Published var selectedTemplateSession: TemplateSession? = nil
    @Published var selectedTemplateSet: TemplateSet? = nil
    @Published var selectedThreshold: SetThreshold? = nil
    @Published var showMenu: Bool = false
    @Published var navPath: [Int] = [Int]()
    @Published var searchText: String = ""
    
}
