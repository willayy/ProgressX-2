//
//  ExerciseLibraryNavigationController.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI

struct ExerciseLibraryNavigationController<Content: View>: View {
    
    var content: Content
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    @Binding var selectedExercise: Exercise?
    @Binding var editingPr: PersonalRecord?
    @Binding var newPrType: String?
    
    init(
        @ViewBuilder content: () -> Content,
        navPath: Binding<[Int]>,
        selectedExercise: Binding<Exercise?>,
        editingPr: Binding<PersonalRecord?>,
        newPrType: Binding<String?>
    ) {
        self._navPath = navPath
        self._selectedExercise = selectedExercise
        self._editingPr = editingPr
        self._newPrType = newPrType
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }
            .navigationDestination(for: Int.self) { selection in
                if selection == 1 {
                    
                    CreateNewExerciseView()
                        .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 2 {
                    
                    EditExerciseView(
                        selectedExercise: $selectedExercise
                    ).environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 3 {
                    
                    StatisticsView(
                        exercise: $selectedExercise,
                        navPath: $navPath,
                        editingPr: $editingPr,
                        newPrType: $newPrType
                    ).environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 4 {
                    
                    EditPrView(
                        editingPr: $editingPr,
                        exercise: $selectedExercise
                    ).environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 5 {
                    
                    CreateNewPersonalRecord(
                        prType: $newPrType,
                        selectedExercise: $selectedExercise
                    ).environment(\.managedObjectContext, viewContext)
                    
                }
            }
        }
    }
}
