//
//  RoutineLibraryView_ViewModel.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import Foundation

class RoutineLibraryViewModel: ObservableObject {
    
    @Published public var selectedRoutine: Routine? = nil
    @Published public var selectedTemplateCycle: TemplateCycle? = nil
    @Published public var selectedTemplateWeek: TemplateWeek? = nil
    @Published public var selectedTemplateSession: TemplateSession? = nil
    @Published public var selectedTemplateSet: TemplateSet? = nil
    @Published public var selectedThreshold: SetThreshold? = nil
    @Published public var showMenu: Bool = false
    @Published public var navPath: [Int] = [Int]()
    @Published public var searchText: String = ""
    
}
