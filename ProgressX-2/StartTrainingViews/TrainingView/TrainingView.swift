//
//  StartWorkoutView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-18.
//


import SwiftUI
import CoreData

struct TrainingView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = TrainingViewModel()
    
    @Binding var navPath: [Int]
    @Binding var selectedRoutine: Routine?
    @Binding var selectedTrainingCycle: TrainingCycle?
    @Binding var selectedTrainingWeek: TrainingWeek?
    @Binding var selectedTrainingSession: TrainingSession?
    @Binding var AllTrainingSets: [TrainingSet]
    @State private var currentTrainingSet: TrainingSet?
    
    @State var selectedHoursAmount: Int = 0
    @State var selectedMinutesAmount: Int = 3
    @State var selectedSecondsAmount: Int = 0
    @State var workoutActive: Bool = false
    @State var presentPopup = false
    
    var body: some View {
        
        @FetchRequest(
            entity: TrainingSet.entity(),
            sortDescriptors: [NSSortDescriptor(keyPath: \TrainingSet.positionIndex, ascending: true)],
            predicate: NSPredicate(format: "trainingSession == %@", selectedTrainingSession!)
        ) var trainingSets: FetchedResults<TrainingSet>

        
        @State var currentsetfortesting = trainingSets.first
        @State var Exercise = currentsetfortesting?.exercise
        
        let timer = TimerView(selectedHoursAmount: $selectedHoursAmount, selectedMinutesAmount: $selectedMinutesAmount, selectedSecondsAmount: $selectedSecondsAmount)
        
        let startButton =
        Button(action:{
            
            print(trainingSets)
            //timer.StartTimer()
            //presentPopup.toggle()
            print(_trainingSets)
            //workoutActive = true
        }) {
            Text("hej")
        }
        VStack{
            timer.frame(width: 150, height: 150)
                .padding(.bottom, 80)
            
            //TrainingElement(currentSet: $currentsetfortesting)
            
            if !workoutActive {
                startButton
            }
        }.popover(isPresented: $presentPopup, content: {
            PopupFeedbackView(currentTrainingSet: $currentsetfortesting, exercise: $Exercise, presentPopup: self.$presentPopup)
        })
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
    allTrainingSets.sorted(by: {$0.positionIndex > $1.positionIndex})
    
    @State var CurrentTrainingSet = allTrainingSets.first
    
    return TrainingView(navPath: $navPath,
                        selectedRoutine: $selectedRoutine,
                        selectedTrainingCycle: $selectedTrainingCycle,
                        selectedTrainingWeek: $selectedTrainingWeek,
                        selectedTrainingSession: $selectedTrainingSession,
                        AllTrainingSets: $allTrainingSets)
        .environment(\.managedObjectContext, context)
}

