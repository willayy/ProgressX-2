//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-17.
//

import Foundation

class StartWorkoutViewModel: ObservableObject {
    
    @Published var selectedRoutine: Routine? = nil
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingCycle: TrainingCycle? = nil
    @Published var selectedTrainingWeek: TrainingWeek? = nil
    @Published var selectedTrainingSession: TrainingSession? = nil
    @Published var AllTrainingSets: [TrainingSet] = []
    @Published var currentTrainingSet: TrainingSet? = nil
    @Published public var searchText: String = ""
    @Published var exercise: Exercise?
    
    @Published public var showMenu: Bool = false
    
}
