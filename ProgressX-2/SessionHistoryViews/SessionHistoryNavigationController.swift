//
//  SessionHistoryNavigationController.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-12.
//

import SwiftUI

struct SessionHistoryNavigationController<Content: View>: View  {
    
    @EnvironmentObject var viewRouter: ViewRouter
    @Environment(\.managedObjectContext) private var viewContext
    
    private var content: Content
    @Binding var navPath: [Int]
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var selectedTrainingSet: TrainingSet?
    
    init(
        navPath: Binding<[Int]>,
        @ViewBuilder content: () -> Content,
        selectedTrainingSession: Binding<TrainingSession?>,
        selectedTrainingSet: Binding<TrainingSet?>
    ) {
        self._navPath = navPath
        self._selectedTrainingSession = selectedTrainingSession
        self._selectedTrainingSet = selectedTrainingSet
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }.navigationDestination(for: Int.self) { selection in
            
                if selection == 1 {
                    
                    SessionHistoryView(navPath: $navPath, selectedTrainingSession: $selectedTrainingSession, selectedTrainingSet: $selectedTrainingSet)
                    
                } else if selection == 2 {
                    
                }
            }
        }
    }
}
