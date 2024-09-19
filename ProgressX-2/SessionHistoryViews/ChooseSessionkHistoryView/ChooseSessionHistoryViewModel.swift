//
//  ChooseWeekHistoryViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-08-12.
//

import Foundation

class ChooseSessionHistoryViewModel: ObservableObject {
    
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingSession: TrainingSession? = nil
    @Published var selectedSet: TrainingSet? = nil
    @Published var searchText: String = ""
    
}
