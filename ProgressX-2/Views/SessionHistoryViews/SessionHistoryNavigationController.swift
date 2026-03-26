//
//  SessionHistoryNavigationController.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-12.
//

import SwiftUI

struct SessionHistoryNavigationController: View  {
    
    @State private var navPath: [Int] = [Int]()
    
    @State private var selectedTrainingSession: TrainingSession? = nil
    
    var body: some View {
        
        NavigationStack(path: $navPath) {
            
            InputFieldForm {
                
                VStack {
                    
                    ChooseSessionHistoryView(
                        navPath: $navPath, 
                        selectedTrainingSession: $selectedTrainingSession
                    )
                    
                }
                .navigationDestination(for: Int.self) { selection in
                    
                    if selection == 1 {
                        
                        SessionHistoryView(
                            selectedTrainingSession: $selectedTrainingSession
                        )
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}
