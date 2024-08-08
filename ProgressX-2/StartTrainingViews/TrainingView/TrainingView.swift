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
            
            #warning("TODO: Make timed sets use the timer (I think it might work but it needs testing)")
            
            // MARK: Which set are you on status text
            Title2(
                text: viewModel.setsLeft(
                    selectedTrainingSession: selectedTrainingSession,
                    currentTrainingSet: currentTrainingSet
                )
            )
            .padding(.bottom, 20)
            
            // MARK: The time progress view
            progressView
            
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
                    if viewModel.doneButtonText == "Start timed set"{
                        viewModel.startTimer(
                            timerViewModel: timerViewModel,
                            seconds: Int(currentTrainingSet!.quantityTodo))
                        viewModel.doneButtonText = "Done"
                    } else if viewModel.doneButtonText == "Done"{
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
                .onChange(of: (timerViewModel.state == .active), initial: false) {
                    if viewModel.doneButtonText == "rest time" {
                        viewModel.doneButtonEnabled.toggle()
                        print("hej")
                    }
                }
            }
                
        }
        .onAppear {
            NotificationCenter.default.addObserver(forName: TimerViewModel.timerDidFinishNotification, object: nil, queue: .main) { _ in
                if viewModel.doneButtonText == "Start rest timer"{
                    viewModel.doneButtonEnabled.toggle()
                    viewModel.doneButtonText = "Start timed set"
                }
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
                dismissButton: .default(Text("Start"))
            )
        } 
        // MARK: Skip set toolbar item.
        .toolbar {
            Button(action:{
                withAnimation {
                    currentTrainingSet!.skip()
                    currentTrainingSet = selectedTrainingSession!.getNextTrainingSet()
                    viewModel.save(viewContext)
                    if currentTrainingSet == nil {
                        navPath.append(3)
                    }
                }
            }) {
                Text("Skip set")
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
                    currentTrainingSet = selectedTrainingSession!.getNextTrainingSet()
                    // if no more sets go to finish screen.
                    if currentTrainingSet == nil {
                        navPath.append(3)
                    } else {
                        // else start rest timer.
                        viewModel.startTimer(
                            timerViewModel: timerViewModel,
                            seconds: Int(currentTrainingSet!.restTime)
                        )
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
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TrainingSession.fetchRequest()
    let trainingSessions = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
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

