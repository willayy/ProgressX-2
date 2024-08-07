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
    
    @Binding var selectedRoutine: Routine?
    @Binding var currentTrainingSet: TrainingSet?
    @Binding var presentPopup: Bool
    @Binding var timeDone: Double?
    
    var body: some View {
        
        let exercise = currentTrainingSet!.exercise!
        
        VStack{
            
            // What is initially shown
            if !viewModel.showDidntFinishAllReps {
                
                // The title chaning depending on what exercise the set was.
                BoldTitle(text: viewModel.getPopupWindowTitle(exercise: exercise))
                
                // MARK: Did you complete all sets
                HStack{
                    
                    // MARK: No i did not complete all sets button.
                    Button(action:{
                        viewModel.showDidntFinishAllReps.toggle()
                    }) {
                        Text("NO")
                            .bold()
                            .frame(width: 120, height: 70)
                    }
                    .tint(.red)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    // MARK: Yes i completed all sets button.
                    Button(action:{
                        
                        if validateInput() {
                            
                            viewModel.setFullyCompleted(currentTrainingSet: currentTrainingSet!)
                            
                            viewModel.checkIfCycleIsFinished(
                                routine: selectedRoutine!,
                                viewContext: viewContext
                            )
                            
                            viewModel.saveEdits(entity: currentTrainingSet!, viewContext: viewContext)
                            
                            self.presentPopup.toggle()
                            
                        }
                        
                    }) {
                        Text("YES")
                            .bold()
                            .frame(width: 120, height: 70)
                    }
                    .tint(.green)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.trailing, 40)
                    
                }
                .padding(.top)
                
            // What is shown if the user didnt finish all reps.
            } else if viewModel.showDidntFinishAllReps {
                
                BoldTitle(text: viewModel.getDidntFinishSetTitle(exercise: exercise))
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Out of a total \(currentTrainingSet!.quantityTodoString!)")
                    .padding(.vertical, 5)
                                
                if exercise.exerciseType == "reps" {
                    
                    IntegerTextField(
                        placeHolder: "Reps",
                        numberText: $viewModel.editedSetQuantity,
                        markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                        errorMessage: $viewModel.editedSetQuantityIsInvalidMsg,
                        allowNegatives: false
                    )
                    .padding(.horizontal, 60)
                    .padding(.top, 5)
                    
                } else if exercise.exerciseType == "time" {
                    
                    DecimalTextField(
                        placeHolder: "Seconds",
                        numberText: $viewModel.editedSetQuantity,
                        markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                        errorMessage: $viewModel.editedSetQuantityIsInvalidMsg,
                        allowNegatives: false
                    )
                    .padding(.horizontal, 60)
                    .padding(.top, 5)
                    .onAppear(perform: {
                        // Take time done from trainingView
                        viewModel.editedSetQuantity = String(format: "%.2f", timeDone!)
                    })
                    
                }
                
                // MARK: Button for when the reps actually done on the set are entered.
                Button(action:{
                    
                    if validateInput() {
                        
                        let quantityDone = Double(viewModel.editedSetQuantity)!
                        
                        viewModel.setPartiallyCompleted(
                            currentTrainingSet: currentTrainingSet!,
                            quantityDone: quantityDone
                        )
                        
                        viewModel.checkIfCycleIsFinished(
                            routine: selectedRoutine!,
                            viewContext: viewContext
                        )
                        
                        viewModel.saveEdits(
                            entity: currentTrainingSet!,
                            viewContext: viewContext
                        )
                        
                        self.presentPopup.toggle()
                        
                    }
                    
                }) {
                    Text("Done")
                        .bold()
                        .frame(width: 120, height: 40)
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top)
            }
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(entity: currentTrainingSet!)
        })
    }
    
    private func validateInput() -> Bool {
        
        var valid: Int = 0
        let exercise = currentTrainingSet!.exercise!
        let inputFieldValidator: InputFieldValidator
        
        if exercise.exerciseType == "reps" { inputFieldValidator = IntFieldValidator() }
        else { inputFieldValidator = DoubleFieldValidator() }
        
        valid += inputFieldValidator.valideField(
            inputVar: viewModel.editedSetQuantity,
            errorMessage: $viewModel.editedSetQuantityIsInvalidMsg,
            fieldInvalid: $viewModel.editedSetQuantityIsInvalid
        )
        
        return valid == 0
    }
    
}



#Preview{
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest = TrainingSet.fetchRequest()
    let trainingSets = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    @State var currentTrainingSet = trainingSets.first
    @State var popupBool: Bool = false
    @State var routine: Routine? = nil
    @State var timeDone: Double? = 5
    
    return PopupFeedbackView(
        selectedRoutine: $routine,
        currentTrainingSet: $currentTrainingSet,
        presentPopup: $popupBool, 
        timeDone: $timeDone
    )
    .environment(\.managedObjectContext, context)
}
