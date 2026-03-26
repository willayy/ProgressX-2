//
//  StartWorkoutNavigationController.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import SwiftUI

struct StartWorkoutNavigationController: View {
    
    @State private var navPath: [Int] = [Int]()
    @State private var selectedRoutine: Routine? = nil
    @State private var selectedTrainingWeek: TrainingWeek? = nil
    @State private var selectedTrainingSession: TrainingSession? = nil
    @State private var currentTrainingSet: TrainingSet? = nil
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    
                    StartWorkoutView(
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTrainingSession: $selectedTrainingSession,
                        currentTrainingSet: $currentTrainingSet
                    )
                    
                }
                .navigationDestination(for: Int.self) { selection in
                    
                    if selection == 1 {
                        
                        ChooseWeekView(
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine,
                            selectedTrainingWeek: $selectedTrainingWeek
                        )
                        
                    } else if selection == 2 {
                        
                        TrainingView(
                            navPath: $navPath,
                            selectedRoutine: $selectedRoutine,
                            selectedTrainingSession: $selectedTrainingSession,
                            currentTrainingSet: $currentTrainingSet
                        )
                        
                    } else if selection == 3 {
                        
                        TrainingSetFinishedView()
                        
                    } else if selection == 4 {
                        
                        ChooseSessionView(
                            navPath: $navPath,
                            selectedTrainingWeek: $selectedTrainingWeek,
                            selectedTrainingSession: $selectedTrainingSession,
                            currentTrainingSet: $currentTrainingSet
                        )
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

