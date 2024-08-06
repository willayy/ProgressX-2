//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import Foundation
import CoreData

class TrainingViewModel: SavingViewModel {
    
    @Published public var selectedRoutine: Routine? = nil
    @Published public var navPath: [Int] = [Int]()
    @Published public var selectedTrainingCycle: TrainingCycle? = nil
    @Published public var selectedTrainingWeek: TrainingWeek? = nil
    @Published public var selectedTrainingSession: TrainingSession? = nil
    @Published public var AllTrainingSets: [TrainingSet] = []
    @Published public var selectedHoursAmount: Int = 0
    @Published public var selectedMinutesAmount: Int = 0
    @Published public var selectedSecondsAmount: Int = 5
    @Published public var showAlert = false
    @Published public var presentPopup = false
    @Published public var startTimer = false
    @Published public var doneButton = false
    @Published public var startTimerButton = false
    @Published public var searchText: String = ""
    
    func secondsToHoursMinutesSeconds(seconds: Int) {
        selectedHoursAmount = seconds / 3600
        selectedMinutesAmount = (seconds % 3600) / 60
        selectedSecondsAmount = (seconds % 3600) % 60
    }
    
    func startTimer(timerViewModel: TimerViewModel){
        selectedHoursAmount = selectedHoursAmount
        selectedMinutesAmount = selectedMinutesAmount
        selectedSecondsAmount = selectedSecondsAmount
        timerViewModel.state = .active
    }
    
}


