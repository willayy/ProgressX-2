//
//  RoutineLibraryNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct RoutineLibraryNavigationController: View {
    
    @State private var navPath: [Int] = [Int]()
    @State private var selectedRoutine: Routine? = nil
    @State private var selectedTemplateCycle: TemplateCycle? = nil
    @State private var selectedTemplateWeek: TemplateWeek? = nil
    @State private var selectedTemplateSession: TemplateSession? = nil
    @State private var selectedTemplateSet: TemplateSet? = nil
    @State private var selectedThreshold: SetThreshold? = nil
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    
                    // MARK: All routines created
                    RoutineLibraryView(
                        selectedRoutine: $selectedRoutine,
                        selectedTemplateCycle: $selectedTemplateCycle,
                        navPath: $navPath
                    )
                    
                }
                .navigationDestination(for: Int.self) { selection in
                    if selection == 1 {
                        
                        // MARK: Create new routine
                        CreateNewRoutineView(
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine,
                            selectedTemplateCycle: $selectedTemplateCycle
                        )
                        
                    } else if selection == 2 {
                        
                        // MARK: Edit routine
                        EditRoutineView(
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine,
                            selectedTemplateCycle: $selectedTemplateCycle,
                            selectedTemplateWeek: $selectedTemplateWeek
                        )
                        
                    } else if selection == 3 {
                        
                        // MARK: Routine statistic
                        RoutineStatisticsView(
                            selectedRoutine: $selectedRoutine
                        )
                        
                    } else if selection == 4 {
                        
                        // MARK: Edit week
                        EditTemplateWeekView(
                            navPath: $navPath,
                            selectedTemplateWeek: $selectedTemplateWeek,
                            selectedTemplateSession: $selectedTemplateSession
                        )
                        
                    } else if selection == 5 {
                        
                        // MARK: Edit session
                        EditTemplateSessionView(
                            navPath: $navPath,
                            selectedTemplateSet: $selectedTemplateSet,
                            selectedTemplateSession: $selectedTemplateSession,
                            selectedThreshold: $selectedThreshold
                        )
                        
                    } else if selection == 6 {
                        
                        // MARK: Edit set
                        EditTemplateSetView(
                            navPath: $navPath,
                            selectedTemplateSet: $selectedTemplateSet
                        )
                        
                    } else if selection == 7 {
                        
                        // MARK: Create new set
                        CreateNewTemplateSetView(
                            navPath: $navPath,
                            selectedTemplateSession: $selectedTemplateSession,
                            selectedTemplateSet: $selectedTemplateSet
                        )
                        
                    } else if selection == 8 {
                        
                        // MARK: Thresholds view
                        ThresholdsView(
                            navPath: $navPath,
                            selectedTemplateSet: $selectedTemplateSet,
                            selectedThreshold: $selectedThreshold
                        )
                        
                    } else if selection == 9 {
                        
                        // MARK: Create Threshold view
                        CreateNewThresholdView(
                            navPath: $navPath,
                            selectedTemplateSet: $selectedTemplateSet
                        )
                        
                    } else if selection == 10 {
                        
                        // MARK: Edit Threshold view
                        EditThresholdsView(
                            navPath: $navPath,
                            selectedThreshold: $selectedThreshold
                        )
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

