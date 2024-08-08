//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import Foundation
import CoreData
import SwiftUI

class TrainingViewModel: SavingViewModel {
    
    @Published public var selectedRoutine: Routine? = nil
    @Published public var navPath: [Int] = [Int]()
    @Published public var selectedTrainingCycle: TrainingCycle? = nil
    @Published public var selectedTrainingWeek: TrainingWeek? = nil
    @Published public var selectedTrainingSession: TrainingSession? = nil
    @Published public var showAlert = false
    @Published public var presentPopup = false
    @Published public var doneButtonEnabled = true
    @Published public var doneButtonText = "Done"
    @Published public var quantityDoneOnTimedSet: Double? = nil
    @Published public var timedSetActive: Bool = false
    
    public func setsLeft(selectedTrainingSession: TrainingSession?, currentTrainingSet: TrainingSet?) -> String {
        let totalSets = selectedTrainingSession?.trainingSets?.count
        let currentSetIndex = currentTrainingSet?.positionIndex
        
        if totalSets == nil || currentSetIndex == nil {
            return "Complete!"
        } else {
            return "Set \(currentSetIndex!) out of \(totalSets!)"
        }
    }
    
    public func doneButtonPressedOnTimedSet(timerViewModel: TimerViewModel) -> Void {
        quantityDoneOnTimedSet = Double(timerViewModel.selectedSecondsAmount - timerViewModel.secondsToCompletion)
        
    }
    
    public func timerStateChangeOnTimedSet(timerViewModel: TimerViewModel) -> Void {
        
        if timerViewModel.state == .active {
            
            withAnimation {
                doneButtonText = "Done"
            }
            
        } else if timerViewModel.state == .cancelled {

            withAnimation {
                doneButtonText = "Start timed set"
            }
            
        }
    }
    
    public func saveTimeOnTimedSet(viewContext: NSManagedObjectContext, set: TrainingSet) -> Void
    {
        set.quantityDone = quantityDoneOnTimedSet!
        self.safeSave(viewContext: viewContext)
    }
    
    public func startTimer(timerViewModel: TimerViewModel, seconds: Int) {
        timerViewModel.selectedHoursAmount = seconds / 3600
        timerViewModel.selectedMinutesAmount = (seconds % 3600) / 60
        timerViewModel.selectedSecondsAmount = (seconds % 3600) % 60
        timerViewModel.state = .active
    }
    
    public func startRestTimerForTimedSet(timer: TimerViewModel) {
        quantityDoneOnTimedSet = Double(timer.selectedSecondsAmount)
        presentPopup.toggle()
        timer.state = .cancelled
        doneButtonText = "rest timer"
        timedSetActive.toggle()
        doneButtonEnabled.toggle()
        
    }
    
}


