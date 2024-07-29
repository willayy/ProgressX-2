//
//  PopupFeedbackView.swift
//  ProgressX-2
//
//  Created by lucas häyhänen on 2024-07-29.
//
import Foundation
import SwiftUI
import CoreData

struct PopupFeedbackView: View {
    
    @StateObject private var viewModel = PopupFeedbackViewModel()
    
    @Environment(\.managedObjectContext) private var viewContext
    
    
    @Binding var currentTrainingSet: TrainingSet?
    @Binding var exercise: Exercise?
    
    @State var text = ""
    @State var ShowWindow: Bool = false
    @Binding var presentPopup: Bool
    
    var body: some View {
        VStack{
            let Question = BoldTitle(text: self.text)
            if !ShowWindow {
                if ((currentTrainingSet?.exercise?.exerciseType = "reps") != nil) {
                    BoldTitle(text: "Did you complete all your reps?")
                } else if ((currentTrainingSet?.exercise?.exerciseType = "time") != nil){
                    BoldTitle(text: "Did you complete the exercise witin the given timeframe")
                }
                
                HStack{
                    Button(action:{
                        print(currentTrainingSet?.exercise?.exerciseType)
                        ShowWindow.toggle()
                        changeText(text: "How many reps did you do?")
                    }) {
                        Text("NO")
                            .bold()
                            .frame(width: 120, height: 70)
                    }
                    .tint(.red)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    Button(action:{
                        viewModel.saveSetChanges(viewContext: viewContext, selectedTrainingSet: currentTrainingSet)
                        self.presentPopup.toggle()
                    }) {
                        Text("YES")
                            .bold()
                            .frame(width: 120, height: 70)
                    }
                    .tint(.green)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.trailing, 40)
                    
                }.padding(.top)
                
                
            } else {
                BoldTitle(text: self.text)
                InputIntegerNumberField(
                    placeHolder: viewModel.quantityPlaceholder(),
                    allowNegatives: false,
                    numberText: $viewModel.editedSetQuantity,
                    markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                )
                .padding(.top, 5)
                
                Button(action:{
                    viewModel.saveSetChanges(viewContext: viewContext, selectedTrainingSet: currentTrainingSet)
                    self.presentPopup.toggle()
                }) {
                    Text("Done")
                        .bold()
                        .frame(width: 120, height: 70)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top)
            }
        }.onAppear(perform: {
            viewModel.setViewStartValues(selectedTrainigeSet: currentTrainingSet)
        })
        
    }
    func changeText(text: String) {
        self.text = text
    }
}



#Preview{
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = Routine.fetchRequest()
    let routines = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    let routine = routines.first!
    
    @State var navPath: [Int] = [Int]()
    var selectedRoutine: Routine? = routine
    let allTrainingCycles = routine.trainingCycles!.allObjects as! [TrainingCycle]
    var selectedTrainingCycle: TrainingCycle? = allTrainingCycles.first!
    
    let allTrainingWeeks = selectedTrainingCycle?.trainingWeeks!.allObjects as! [TrainingWeek]
    var selectedTrainingWeek: TrainingWeek? = allTrainingWeeks.first!
    
    let allTrainingSessions = selectedTrainingWeek?.trainingSessions!.allObjects as! [TrainingSession]
    var selectedTrainingSession: TrainingSession? = allTrainingSessions.first(where: {$0.timePeriodName == "Session 1"})
    
    var allTrainingSets = selectedTrainingSession?.trainingSets!.allObjects as! [TrainingSet]
    allTrainingSets.sorted(by: {$0.positionIndex > $1.positionIndex})
    
    @State var CurrentTrainingSet = allTrainingSets.first
    
    @State var Exercise = CurrentTrainingSet!.exercise
    
    @State var popupbool: Bool = false
    
    return PopupFeedbackView(currentTrainingSet: $CurrentTrainingSet, exercise: $Exercise, presentPopup: $popupbool).environment(\.managedObjectContext, context)
}
