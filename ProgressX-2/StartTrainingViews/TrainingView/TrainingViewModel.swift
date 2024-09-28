//
//  StartWorkoutViewModel.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//

import Foundation
import CoreData
import SwiftUI

class TrainingViewModel: ViewModel {
    
    @Published public var selectedRoutine: Routine? = nil
    @Published public var navPath: [Int] = [Int]()
    @Published public var showAlert = false
    @Published public var presentPopup = false
    @Published public var doneButtonEnabled = true
    @Published public var doneButtonText = "Done"
    @Published public var quantityDoneOnTimedSet: Double? = nil
    @Published public var timedSetActive: Bool = false
    @Published public var lastExercise: String = ""
    @Published public var secondsElapsed: Int = 0
    
    var timerForSessionLength: Timer = Timer()
    
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
    
    public func setLastExercise(exercise: String){
        lastExercise = exercise
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
        self.save(viewContext)
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
    
    public func getNextSetAfterThis(session: TrainingSession, currSet: TrainingSet) -> TrainingSet? {
        
        let uncompletedSets = session.children
            .filter { !$0.isComplete }
        
        let setAfterThis: TrainingSet? = uncompletedSets[1]
        
        if setAfterThis == nil || setAfterThis == currSet {
            
            return nil
            
        } else {
            
            return setAfterThis
            
        }
        
    }
    
    public func startSessionTimer() {
            timerForSessionLength = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.secondsElapsed += 1
            }
        }
    
    public func stopSessionTimer() {
            timerForSessionLength.invalidate()
            secondsElapsed = 0
        }
    
    public func updateStatesWhenTimerStops(trainingSet: TrainingSet){
        
       if trainingSet.exercise!.exerciseType! == "time" && lastExercise == "reps" {
           doneButtonText = "Start timed set"
           timedSetActive = true
           doneButtonEnabled.toggle()
       } else if trainingSet.exercise!.exerciseType! == "reps" && lastExercise == "time" {
           timedSetActive = false
       } else if trainingSet.exercise?.exerciseType! == "time" && doneButtonText == "rest timer"{
           doneButtonEnabled.toggle()
           timedSetActive = true
           doneButtonText = "Start timed set"
       }
       if doneButtonText == "Start rest timer"{
           doneButtonEnabled.toggle()
           doneButtonText = "Start timed set"
       }
    }
}


