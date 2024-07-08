//
//  RoutineLibraryNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct RoutineLibraryNavigationController<Content: View>: View {
    
    var content: Content
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTemplateCycle: TemplateCycle?
    @Binding var selectedTemplateWeek: TemplateWeek?
    @Binding var selectedTemplateSession: TemplateSession?
    @Binding var selectedTemplateSet: TemplateSet?
    @Binding var selectedThreshold: SetThreshold?
    
    init(
        @ViewBuilder content: () -> Content,
        navPath: Binding<[Int]>,
        selectedRoutine: Binding<Routine?>,
        selectedTemplateCycle: Binding<TemplateCycle?>,
        selectedTemplateWeek: Binding<TemplateWeek?>,
        selectedTemplateSession: Binding<TemplateSession?>,
        selectedTemplateSet: Binding<TemplateSet?>,
        selectedThreshold: Binding<SetThreshold?>
    ) {
        self._navPath = navPath
        self._selectedRoutine = selectedRoutine
        self._selectedTemplateCycle = selectedTemplateCycle
        self._selectedTemplateWeek = selectedTemplateWeek
        self._selectedTemplateSession = selectedTemplateSession
        self._selectedTemplateSet = selectedTemplateSet
        self._selectedThreshold = selectedThreshold
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }
            .navigationDestination(for: Int.self) { selection in
                if selection == 1 {
                    
                    // MARK: Create new routine
                    CreateNewRoutineView(
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTemplateCycle: $selectedTemplateCycle
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 2 {
                    
                    // MARK: Edit routine
                    EditRoutineView(
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTemplateCycle: $selectedTemplateCycle,
                        selectedTemplateWeek: $selectedTemplateWeek
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 3 {
                    
                    // MARK: Routine statistic
                    RoutineStatisticsView()
                    
                } else if selection == 4 {
                    
                    // MARK: Edit week
                    EditTemplateWeekView(
                        navPath: $navPath,
                        selectedTemplateWeek: $selectedTemplateWeek,
                        selectedTemplateSession: $selectedTemplateSession
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 5 {
                    
                    // MARK: Edit session
                    EditTemplateSessionView(
                        navPath: $navPath,
                        selectedTemplateSet: $selectedTemplateSet,
                        selectedTemplateSession: $selectedTemplateSession,
                        selectedThreshold: $selectedThreshold
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 6 {
                    
                    // MARK: Edit set
                    EditTemplateSetView(
                        navPath: $navPath,
                        selectedTemplateSet: $selectedTemplateSet
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 7 {
                    
                    // MARK: Create new set
                    CreateNewTemplateSetView(
                        navPath: $navPath,
                        selectedTemplateSession: $selectedTemplateSession
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 8 {
                    
                    // MARK: Thresholds view
                    ThresholdsView(
                        navPath: $navPath,
                        selectedTemplateSet: $selectedTemplateSet,
                        selectedThreshold: $selectedThreshold
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 9 {
                    
                    // MARK: Create Threshold view
                    CreateNewThresholdView(
                        navPath: $navPath,
                        selectedTemplateSet: $selectedTemplateSet
                    )
                    
                } else if selection == 10 {
                    // MARK: Edit Threshold view
                    
                }
            }
        }
    }
}

