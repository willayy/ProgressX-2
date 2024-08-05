//
//  TrainingSetFinishedViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-05.
//

import Foundation

class TrainingSetFinishedViewModel: ObservableObject {
    @Published var selectedRoutine: Routine? = nil
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingCycle: TrainingCycle? = nil
    @Published var selectedTrainingWeek: TrainingWeek? = nil
    @Published var selectedTrainingSession: TrainingSession? = nil
    @Published var AllTrainingSets: [TrainingSet] = []
    @Published public var searchText: String = ""
    
    
}
