//
//  SessionHistoryViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-14.
//

import Foundation

class SessionHistoryViewModel: ObservableObject{
    
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingSession: TrainingSession? = nil
    
}
