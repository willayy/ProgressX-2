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
    
    @StateObject public var timerViewModel = TimerViewModel()
    
    @Binding var navPath: [Int]
    
    @Binding var selectedRoutine: Routine?
    
    @Binding var selectedTrainingSession: TrainingSession?
    
    @Binding var currentTrainingSet: TrainingSet?
    
    var body: some View {
    
        let exerciseType = currentTrainingSet?.exercise!.exerciseType!
        
        VStack {
            
            // MARK: Which set are you on status text
            Title2(
                
                text: viewModel.setsLeft(
                    selectedTrainingSession: selectedTrainingSession,
                    currentTrainingSet: currentTrainingSet
                )
                
            )
            .padding(.bottom, 20)
            
            // MARK: The time progress view
            // Only displays the timer if it is counting
            if timerViewModel.state == .active {
                
                withAnimation {
                    
                    progressView
                    
                }
                
            }
            
            
            // MARK: Skip rest time button
            if timerViewModel.state == .active && !viewModel.timedSetActive {
                
                withAnimation {
                    
                    Button {
                        
                        timerViewModel.state = .cancelled
                        
                        if viewModel.doneButtonText == "rest timer" {
                            
                            viewModel.doneButtonEnabled.toggle()
                            
                            viewModel.doneButtonText = "Start timed set"
                            
                            viewModel.timedSetActive.toggle()
                            
                        }
                        
                    } label: {
                        
                        Text("Skip rest")
                            .font(.title)
                        
                    }
                    .padding(.bottom, 10)
                    
                }
                
            }
            
            // MARK: The information box about the set
            TrainingSetInfoBox(currentTrainingSet: $currentTrainingSet)
            
            BoldSubHeadline(text: "Next set coming up")
                .padding(.top, 10)
            
            Text(viewModel.nextTrainingSet?.timePeriodName ?? "This is the last set")
                .font(.subheadline)
            
            if viewModel.nextTrainingSet != nil {
                    
                GroupBox {
                    
                    VStack(alignment: .leading, spacing: 5) {
                        
                        LightSubHeadline(text: "Load: \( viewModel.nextTrainingSet!.formattedLoadTodo)")
                        
                        LightSubHeadline(text: "Quantity: \(viewModel.nextTrainingSet!.formattedQuantityTodo!)")
                        
                    }
                    
                }
                
            }
            
            if exerciseType == "reps" {
                
                // MARK: Set done button but for rep
                Button(action:{
                    
                    viewModel.presentPopup.toggle()
                    
                }) {
                    
                    Text(viewModel.doneButtonText)
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                .disabled(!viewModel.doneButtonEnabled)
                .onChange(of: (timerViewModel.state == .active), initial: false) {
                    
                    viewModel.doneButtonEnabled.toggle()
                    
                }
                
            } else if exerciseType == "time" {
                
                // MARK: Set done button but for timed sets
                Button(action:{
                    
                    if viewModel.doneButtonText == "Start timed set" {
                        
                        viewModel.startTimer(
                            timerViewModel: timerViewModel,
                            seconds: Int(currentTrainingSet!.quantityTodo)
                        )
                        
                        viewModel.doneButtonText = "Done"
                        
                    } else if viewModel.doneButtonText == "Done" {
                        
                        viewModel.startRestTimerForTimedSet(timer: timerViewModel)
                        
                    }
                    
                }) {
                    
                    Text(viewModel.doneButtonText)
                        .frame(width: 150, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                .disabled(!viewModel.doneButtonEnabled)
            }
                
        }
        .onAppear {
            
            if currentTrainingSet != nil{
                viewModel.setNextSetAfterThis(session: selectedTrainingSession!, currSet: currentTrainingSet!)
            }
            NotificationCenter.default.addObserver(forName: TimerViewModel.timerDidFinishNotification, object: nil, queue: .main) { _ in
                viewModel.updateStatesWhenTimerStops(trainingSet: currentTrainingSet!)
            }
        }
        // MARK: Task to show start session alert.
        .task {
            
            withAnimation {
                
                if exerciseType == "time"{
                    
                    viewModel.doneButtonText = "Start timed set"
                    
                    viewModel.timedSetActive = true
                    
                }
                
                viewModel.showAlert = true
                
            }
            
        }
        // MARK: Start your new set alert.
        .alert(isPresented: $viewModel.showAlert) {
            
            Alert(
                title: Text("Ready to start your session?"),
                message: Text("Press start to get going with your first set!"),
                dismissButton: .default(Text("Start")){
                    viewModel.startSessionTimer()
                }
            )
            
        }
        // MARK: Skip set toolbar item.
        .toolbar {
            
            // Displays the total elapsed time of the Session
            ToolbarItem(placement: .principal) {
                
                Text(viewModel.secondsElapsed.asTimestamp)
            }
            
            ToolbarItem {
                
                Button(action: {
                    
                    withAnimation {
                        
                        currentTrainingSet!.skip()
                        
                        currentTrainingSet = selectedTrainingSession!.nextTrainingSet
                        
                        viewModel.save(viewContext)
                        
                        if currentTrainingSet == nil {
                            
                            viewModel.stopSessionTimer()
                            
                            navPath.append(3)
                            
                        }
                    }
                }) {
                    
                    Text("Skip set")
                    
                }
            }
        }
        // MARK: Set finished feedback view.
        .popover(isPresented: $viewModel.presentPopup, content: {
            
            PopupFeedbackView(
                selectedRoutine: $selectedRoutine,
                currentTrainingSet: $currentTrainingSet,
                presentPopup: $viewModel.presentPopup,
                timeDone: $viewModel.quantityDoneOnTimedSet
            )
            .onDisappear(perform: {
                
                withAnimation {
                    
                    viewModel.startTimer(
                        timerViewModel: timerViewModel,
                        seconds: Int(currentTrainingSet!.restTime)
                    )
                    
                    viewModel.lastExercise = (currentTrainingSet?.exercise!.exerciseType!)!
                    
                    currentTrainingSet = selectedTrainingSession!.nextTrainingSet
                    
                    if currentTrainingSet?.exercise!.exerciseType! == "time" && viewModel.lastExercise == "reps" {
                        
                        viewModel.doneButtonEnabled.toggle()
                        
                        viewModel.doneButtonText = "rest timer"
                        
                    } else if currentTrainingSet?.exercise!.exerciseType! == "reps" && viewModel.lastExercise == "time" {
                        
                        viewModel.doneButtonText = "Done"
                        
                    }
                    
                    // if no more sets go to finish screen.
                    if currentTrainingSet == nil {
                        
                        viewModel.stopSessionTimer()
                        
                        timerViewModel.state = .cancelled
                        
                        navPath.append(3)
                        
                    }
                }
            })
        })
    }
    
    var progressView: some View {
        
            ZStack {
                
                    withAnimation {
                        
                        CircleProgressView(progress: $timerViewModel.progress)
                        
                    }

                // display information about the current set
                VStack {
                    
                    Text(timerViewModel.secondsToCompletion.asTimestamp)
                        .font(.largeTitle)
                        .foregroundColor(.black)
                    
                }
            }
        
        .frame(width: 360, height: 255)
        .padding(.bottom, 20)
    }
    
}
    
#Preview {
    let context = PersistenceController.previewViewContext
    let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
    let trainingSessions = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    let trainingSession: TrainingSession? = trainingSessions.first
    let trainingSets = trainingSession?.trainingSets?.allObjects as! [TrainingSet]
    let trainingSet: TrainingSet? = trainingSets.first
    
    @State var selectedTrainingSession = trainingSession
    @State var currentTrainingSet = trainingSet
    @State var navPath = [Int]()
    @State var routine: Routine? = nil
    
    return TrainingView(
        navPath: $navPath,
        selectedRoutine: $routine, 
        selectedTrainingSession: $selectedTrainingSession,
        currentTrainingSet: $currentTrainingSet
    )
    .environment(\.managedObjectContext, context)
}

