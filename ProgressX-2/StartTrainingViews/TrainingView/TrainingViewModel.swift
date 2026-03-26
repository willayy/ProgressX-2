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
    @Published public var nextTrainingSet: TrainingSet? = nil
    
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
        self.lastExercise = exercise
    }
    
    public func timerStateChangeOnTimedSet(timerViewModel: TimerViewModel) -> Void {
        
        if timerViewModel.state == .active {
            
            withAnimation {
                self.doneButtonText = "Done"
            }
            
        } else if timerViewModel.state == .cancelled {

            withAnimation {
                self.doneButtonText = "Start timed set"
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
        self.quantityDoneOnTimedSet = Double(timer.selectedSecondsAmount)
        self.presentPopup.toggle()
        timer.state = .cancelled
        self.doneButtonText = "rest timer"
        self.timedSetActive.toggle()
        self.doneButtonEnabled.toggle()
        
    }
    
    
    
    public func setNextSetAfterThis(session: TrainingSession, currSet: TrainingSet) -> Void {
        
        let uncompletedSets = session.children
            .filter { !$0.isComplete }
        
        if uncompletedSets.count < 2 {
            self.nextTrainingSet = nil
            return
        }
        
        let setAfterThis: TrainingSet? = uncompletedSets[1]
        
        if setAfterThis == currSet {
            
            self.nextTrainingSet = nil
            
        } else {
            
            self.nextTrainingSet = setAfterThis
            
        }
        
    }
    
    public func startSessionTimer() {
            self.timerForSessionLength = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
                self.secondsElapsed += 1
            }
        }
    
    public func stopSessionTimer() {
            self.timerForSessionLength.invalidate()
            self.secondsElapsed = 0
        }
    
    public func updateStatesWhenTimerStops(trainingSet: TrainingSet){
        
       if trainingSet.exercise!.exerciseType! == "time" && self.lastExercise == "reps" {
           self.doneButtonText = "Start timed set"
           self.timedSetActive = true
           self.doneButtonEnabled.toggle()
       } else if trainingSet.exercise!.exerciseType! == "reps" && self.lastExercise == "time" {
           self.timedSetActive = false
       } else if trainingSet.exercise?.exerciseType! == "time" && self.doneButtonText == "rest timer"{
           self.doneButtonEnabled.toggle()
           self.timedSetActive = true
           self.doneButtonText = "Start timed set"
       }
       if self.doneButtonText == "Start rest timer"{
           self.doneButtonEnabled.toggle()
           self.doneButtonText = "Start timed set"
       }
    }
}


