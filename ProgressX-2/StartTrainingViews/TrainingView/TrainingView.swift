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
    @ObservedObject public var timerViewModel = TimerViewModel()
    
    @Binding var navPath: [Int]
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var currentTrainingSet: TrainingSet?
    
    var body: some View {
    
        VStack {
            
            progressView
            
            if currentTrainingSet != nil {
                TrainingElement(currentSet: $currentTrainingSet)
            }
    
            if !viewModel.doneButton {
                Button(action:{
                    viewModel.presentPopup.toggle()
                }) {
                    Text("Done")
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                
            } else {
                
                Button(action:{
                    viewModel.startTimer(timerViewModel: timerViewModel)
                    viewModel.startTimerButton = true
                }) {
                    Text("Start timer")
                        .frame(width: 100, height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                }
                .disabled(viewModel.startTimerButton)
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
            }
        }
        .task {
            viewModel.secondsToHoursMinutesSeconds(seconds: Int(5))
        }
        .onAppear {
            NotificationCenter.default.addObserver(
                forName: TimerViewModel.timerDidFinishNotification,
                object: nil,
                queue: .main
            ) { _ in
                viewModel.showAlert = true
                viewModel.startTimerButton = false
            }
        }
        .onDisappear {
            NotificationCenter.default.removeObserver(self)
        }
        .alert("Start your next set",isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) { viewModel.doneButton.toggle() }
        }
        .toolbar {
            Button(action:{
                currentTrainingSet!.skip()
                currentTrainingSet = viewModel.getNextIncompleteSet(session: selectedTrainingSession!)
                viewModel.safeSave(viewContext: viewContext)
                if currentTrainingSet == nil { navPath.append(3) }
                viewModel.secondsToHoursMinutesSeconds(seconds: Int(currentTrainingSet!.restTime))
            }) {
                Text("Skip set")
            }
        }
        .popover(isPresented: $viewModel.presentPopup, content: {
            PopupFeedbackView(
                currentTrainingSet: $currentTrainingSet,
                presentPopup: $viewModel.presentPopup
            )
            .onDisappear(perform: {
                currentTrainingSet = viewModel.getNextIncompleteSet(session: selectedTrainingSession!)
                if currentTrainingSet == nil { navPath.append(3) }
                //secondsToHoursMinutesSeconds(seconds: Int(currentTrainingSet!.restTime))
                viewModel.doneButton.toggle()
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
        .padding(.all, 32)
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
    
    return TrainingView(
        navPath: $navPath,
        selectedTrainingSession: $selectedTrainingSession,
        currentTrainingSet: $currentTrainingSet
    )
    .environment(\.managedObjectContext, context)
}

