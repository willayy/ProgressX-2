//
//  StartWorkoutNavigationController.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import SwiftUI

struct StartWorkoutNavigationController<Content: View>: View {
    
    public var content: Content
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingCycle: TrainingCycle?
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var AllTrainingSets: [TrainingSet]
    @Binding var currentTrainingSet: TrainingSet?
    @Binding var exercise: Exercise?
    
    init(
        
    @ViewBuilder content: () -> Content,
    navPath: Binding<[Int]>,
    selectedRoutine: Binding<Routine?>,
    selectedTrainingCycle: Binding<TrainingCycle?>,
    selectedTrainingWeek: Binding<TrainingWeek?>,
    selectedTrainingSession: Binding<TrainingSession?>,
    AllTrainingSets: Binding<[TrainingSet]>,
    currentTrainingSet: Binding<TrainingSet?>,
    exercise: Binding<Exercise?>
    
    ) {
        
        self._navPath = navPath
        self._selectedRoutine = selectedRoutine
        self._selectedTrainingCycle = selectedTrainingCycle
        self._selectedTrainingWeek = selectedTrainingWeek
        self._selectedTrainingSession = selectedTrainingSession
        self._AllTrainingSets = AllTrainingSets
        self._currentTrainingSet = currentTrainingSet
        self._exercise = exercise
        
        self.content = content()
        
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }.navigationDestination(for: Int.self) { selection in
                if selection == 1 {
                    
                    // TODO: Create Training View
                    ChooseWeekView(
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTrainingCycle: $selectedTrainingCycle,
                        selectedTrainingWeek: $selectedTrainingWeek)
                        .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 2 {
                    
                    TrainingView(
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTrainingCycle: $selectedTrainingCycle,
                        selectedTrainingWeek: $selectedTrainingWeek,
                        selectedTrainingSession: $selectedTrainingSession,
                        AllTrainingSets: $AllTrainingSets,
                        currentTrainingSet: $currentTrainingSet, Exercise: $exercise)
                        .environment(\.managedObjectContext, viewContext)
                    // TODO: Create choose week
                    
                } else if selection == 3 {
                    
                    // TODO: Create
                    TrainingSetFinishedView(navPath: $navPath)
                    
                }
            }

        }
    }
    
}

