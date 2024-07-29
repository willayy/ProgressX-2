//
//  ChooseWeekViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//
import Foundation

class ChooseWeekViewModel: ObservableObject {
    
    @Published var selectedRoutine: Routine? = nil
    @Published var navPath: [Int] = [Int]()
    @Published var selectedTrainingCycle: TrainingCycle? = nil
    @Published var selectedTrainingWeek: TrainingWeek? = nil
    @Published public var searchText: String = ""
    
    @Published public var showMenu: Bool = false
    
}
