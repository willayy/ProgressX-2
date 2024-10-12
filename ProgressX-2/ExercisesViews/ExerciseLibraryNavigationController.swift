//
//  ExerciseLibraryNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct ExerciseLibraryNavigationController<Content: View>: View {
    
    private var content: Content
    @Binding var navPath: [Int]
    @Binding var selectedExercise: Exercise?
    @Binding var editingPr: PersonalRecord?
    @Binding var newPrType: String?
    
    init(
        navPath: Binding<[Int]>,
        selectedExercise: Binding<Exercise?>,
        editingPr: Binding<PersonalRecord?>,
        newPrType: Binding<String?>,
        @ViewBuilder content: () -> Content
    ) {
        self._navPath = navPath
        self._selectedExercise = selectedExercise
        self._editingPr = editingPr
        self._newPrType = newPrType
        self.content = content()
    }
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    
                    content
                    
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
