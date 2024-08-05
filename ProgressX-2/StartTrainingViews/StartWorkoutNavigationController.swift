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
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var currentTrainingSet: TrainingSet?
    
    init(
        navPath: Binding<[Int]>,
        selectedRoutine: Binding<Routine?>,
        selectedTrainingWeek: Binding<TrainingWeek?>,
        selectedTrainingSession: Binding<TrainingSession?>,
        currentTrainingSet: Binding<TrainingSet?>,
        @ViewBuilder content: () -> Content
    ) {
        self._navPath = navPath
        self._selectedRoutine = selectedRoutine
        self._selectedTrainingWeek = selectedTrainingWeek
        self._selectedTrainingSession = selectedTrainingSession
        self._currentTrainingSet = currentTrainingSet
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }.navigationDestination(for: Int.self) { selection in
                if selection == 1 {
                    
                    ChooseWeekView(
                        navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTrainingWeek: $selectedTrainingWeek
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 2 {
                    
                    TrainingView(
                        navPath: $navPath,
                        selectedTrainingSession: $selectedTrainingSession,
                        currentTrainingSet: $currentTrainingSet
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 3 {
                    
                    TrainingSetFinishedView(
                        navPath: $navPath
                    )
                    .environment(\.managedObjectContext, viewContext)
                    
                } else if selection == 4 {
                    
                    ChooseSessionView(
                        navPath: $navPath,
                        selectedTrainingWeek: $selectedTrainingWeek,
                        selectedTrainingSession: $selectedTrainingSession
                    )
                    
                }
            }

        }
    }
    
}

