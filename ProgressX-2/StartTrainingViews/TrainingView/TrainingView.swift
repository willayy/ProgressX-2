//
//  StartWorkoutView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//


import SwiftUI
import CoreData
import Foundation

struct TrainingView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TrainingViewModel()
    @ObservedObject public var TimerviewModel = TimerViewModel()
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingCycle: TrainingCycle?
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var AllTrainingSets: [TrainingSet]
    @Binding var currentTrainingSet: TrainingSet?
    @Binding var Exercise: Exercise?
    
    @State var selectedHoursAmount: Int = 0
    @State var selectedMinutesAmount: Int = 0
    @State var selectedSecondsAmount: Int = 5
    @State var showAlert = false
    @State var presentPopup = false
    @State var startTimer = false
    @State var DoneButton = false
    @State var startTimerButton = false
    
    var body: some View {
    
        VStack{
            
            progressView
            if currentTrainingSet != nil {
                TrainingElement(currentSet: $currentTrainingSet)
            }
    
            if !DoneButton {
                Button(action:{
                    presentPopup.toggle()
                }) {
                    Text("Done")
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                
            } else {
                
                Button(action:{
                    print(selectedSecondsAmount)
                    startTimer(Timer: TimerviewModel)
                    startTimerButton = true
                }) {
                    Text("Start timer")
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                }.disabled(startTimerButton)
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                }
        }
        .task {
            secondsToHoursMinutesSeconds(seconds: Int(5))
        }
        .alert("Start your next set",isPresented: $showAlert) {
            Button("OK", role: .cancel) { DoneButton.toggle()}
                }
                .onAppear {
                    NotificationCenter.default.addObserver(forName: TimerViewModel.timerDidFinishNotification, object: nil, queue: .main) { _ in
                        showAlert = true
                        startTimerButton = false
                    }
                }
                .onDisappear {
                    NotificationCenter.default.removeObserver(self)
                }
        .toolbar {
            Button(action:{
                viewModel.saveEdits(entity: currentTrainingSet!, viewContext: viewContext)
                currentTrainingSet = AllTrainingSets.first(where: {!$0.isComplete})
                if currentTrainingSet == nil {
                    navPath.append(3)
                }
                secondsToHoursMinutesSeconds(seconds: Int(currentTrainingSet!.restTime))
            }) {
                Text("Skip set")
            }
        }
        .popover(isPresented: $presentPopup, content: {
            PopupFeedbackView(currentTrainingSet: $currentTrainingSet, exercise: $Exercise, presentPopup: self.$presentPopup).onDisappear(perform: {
                
                currentTrainingSet = AllTrainingSets.first(where: {!$0.isComplete})
                if currentTrainingSet == nil {
                    navPath.append(3)
                }
                //secondsToHoursMinutesSeconds(seconds: Int(currentTrainingSet!.restTime))
                DoneButton.toggle()
            })
        })
    }
    var progressView: some View {
        
            ZStack {
                withAnimation {
                    CircleProgressView(progress: $TimerviewModel.progress)
                }
                
                VStack {
                    Text(TimerviewModel.secondsToCompletion.asTimestamp)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                }  
            }
        
        .frame(width: 360, height: 255)
        .padding(.all, 32)
    }
    
    func secondsToHoursMinutesSeconds(seconds: Int) {
        selectedHoursAmount = seconds / 3600
        selectedMinutesAmount = (seconds % 3600) / 60
        selectedSecondsAmount = (seconds % 3600) % 60
    }
    
    func startTimer(Timer: TimerViewModel){
        TimerviewModel.selectedHoursAmount = selectedHoursAmount
        TimerviewModel.selectedMinutesAmount = selectedMinutesAmount
        TimerviewModel.selectedSecondsAmount = selectedSecondsAmount
        TimerviewModel.state = .active
    }
}
    



#Preview {
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = Routine.fetchRequest()
    let routines = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let routine = routines.first!
    
    @State var navPath: [Int] = [Int]()
    @State var selectedRoutine: Routine? = routine
    let allTrainingCycles = routine.trainingCycles!.allObjects as! [TrainingCycle]
    @State var selectedTrainingCycle: TrainingCycle? = allTrainingCycles.first!
    
    let allTrainingWeeks = selectedTrainingCycle?.trainingWeeks!.allObjects as! [TrainingWeek]
    @State var selectedTrainingWeek: TrainingWeek? = allTrainingWeeks.first!
    
    let allTrainingSessions = selectedTrainingWeek?.trainingSessions!.allObjects as! [TrainingSession]
    @State var selectedTrainingSession: TrainingSession? = allTrainingSessions.first(where: {$0.timePeriodName == "Session 1"})
    
    @State var allTrainingSets = selectedTrainingSession?.trainingSets!.allObjects as! [TrainingSet]
    
    @State var CurrentTrainingSet = allTrainingSets.first
    
    @State var Exercise = CurrentTrainingSet?.exercise
    
    return TrainingView(navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTrainingCycle: $selectedTrainingCycle,
                        selectedTrainingWeek: $selectedTrainingWeek,
                        selectedTrainingSession: $selectedTrainingSession,
                        AllTrainingSets: $allTrainingSets,
                        currentTrainingSet: $CurrentTrainingSet, Exercise: $Exercise)
        .environment(\.managedObjectContext, context)
}

