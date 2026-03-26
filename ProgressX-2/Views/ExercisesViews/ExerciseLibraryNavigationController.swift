//
//  ExerciseLibraryNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct ExerciseLibraryNavigationController: View {
    
    @State private var navPath: [Int] = [Int]()
    
    @State private var selectedExercise: Exercise? = nil
    
    @State private var editingPr: PersonalRecord? = nil
    
    @State private var newPrType: String? = nil
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    
                    ExerciseLibraryView(
                        navPath: $navPath,
                        selectedExercise: $selectedExercise
                    )
                    
                }
                .navigationDestination(for: Int.self) { selection in
                    
                    if selection == 1 {
                        
                        CreateNewExerciseView(
                            navPath: $navPath
                        )
                        
                    } else if selection == 2 {
                        
                        EditExerciseView(
                            selectedExercise: $selectedExercise
                        )
                        
                    } else if selection == 3 {
                        
                        StatisticsView(
                            exercise: $selectedExercise,
                            navPath: $navPath,
                            editingPr: $editingPr,
                            newPrType: $newPrType
                        )
                        
                    } else if selection == 4 {
                        
                        EditPrView(
                            editingPr: $editingPr,
                            exercise: $selectedExercise
                        )
                        
                    } else if selection == 5 {
                        
                        CreateNewPersonalRecord(
                            prType: $newPrType,
                            navPath: $navPath,
                            selectedExercise: $selectedExercise
                        )
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
