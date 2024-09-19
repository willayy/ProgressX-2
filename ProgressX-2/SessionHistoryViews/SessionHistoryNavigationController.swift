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
    @Binding var selectedSet: TrainingSet?
    
    
    
    init(
        navPath: Binding<[Int]>,
        @ViewBuilder content: () -> Content,
        selectedTrainingSession: Binding<TrainingSession?>,
        selectedSet: Binding<TrainingSet?>
    ) {
        self._navPath = navPath
        self._selectedTrainingSession = selectedTrainingSession
        self._selectedSet = selectedSet
        self.content = content()
    }
    
    var body: some View {
        NavigationStack(path: $navPath) {
            VStack {
                content
            }.navigationDestination(for: Int.self) { selection in
            
                if selection == 1 {
                    SessionHistoryView(navPath: $navPath, selectedTrainingSession: $selectedTrainingSession)
                    
                } else if selection == 2 {
                    SetHistoryView(navPath: $navPath, selectedSet: $selectedSet)
                }
            }
        }
    }
}
