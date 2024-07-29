//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import Foundation

class TrainingViewModel: ObservableObject {
    @Published var selectedRoutine: Routine? = nil
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingCycle: TrainingCycle? = nil
    @Published var selectedTrainingWeek: TrainingWeek? = nil
    @Published var selectedTrainingSession: TrainingSession? = nil
    @Published var AllTrainingSets: [TrainingSet] = []
    @Published public var searchText: String = ""
    
    
}
