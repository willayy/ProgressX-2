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
                    .padding(.horizontal, 40)
                
                Title2(text: "on \(currentTrainingSet!.timePeriodName!)?")
                    .padding(.bottom)
                    
                
                // MARK: Did you complete all sets
                HStack{
                    
                    // MARK: No i did not complete all sets button.
                    Button(action:{
                        
                        viewModel.showDidntFinishAllReps.toggle()
                        
                    }) {
                        
                        Text("NO")
                            .bold()
                            .frame(width: 120, height: 55)
                        
                    }
                    .tint(.red)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.leading, 40)
                    
                    Spacer()
                    
                    // MARK: Yes i completed all sets button.
                    Button(action:{
                            
                        viewModel.setFullyCompleted(currentTrainingSet: currentTrainingSet!)
                        
                        viewModel.checkIfCycleIsFinished(
                            routine: selectedRoutine!,
                            viewContext: viewContext
                        )
                        
                        viewModel.saveEntry(viewContext: viewContext)
                                                    
                        self.presentPopup.toggle()
                        
                    }) {
                        Text("YES")
                            .bold()
                            .frame(width: 120, height: 55)
                    }
                    .tint(.green)
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.trailing, 40)
                    
                }
                .padding(.horizontal, 20)
                
            // What is shown if the user didnt finish all reps.
            } else if viewModel.showDidntFinishAllReps {
                
                BoldTitle(text: viewModel.getDidntFinishSetTitle(exercise: exercise))
                    .padding(.horizontal, 20)
                
                LightSubHeadline(text: "Out of a total \(currentTrainingSet!.formattedQuantityTodo!)")
                    .padding(.vertical, 5)
                
                // Variables for the inputfield
                let exerciseType = exercise.exerciseType
                
                let placeHolder = exerciseType == "reps" ? "Reps" : "Secoonds"
                
                let variant = exerciseType == "reps" ? IntegerIF(min: 0, max: 100000) : DecimalIF(min: 0, max: 100000)
                
                InputField(
                    placeHolder: placeHolder,
                    text: $viewModel.editedSetQuantity,
                    variant: variant
                )
                .padding(.horizontal, 60)
                .padding(.top, 5)
                .onAppear(perform: {
                    
                    if exerciseType == "reps" {
                        
                        // Take time done from trainingView
                        viewModel.editedSetQuantity = String(format: "%.2f", timeDone!)
                        
                    }
                    
                })
                
                // MARK: Button for when the reps actually done on the set are entered.
                Button(action:{
                    
                    if GlobalInputFieldValidator.allFieldsValid() {
                        
                        let quantityDone = Double(viewModel.editedSetQuantity)!
                        
                        viewModel.setPartiallyCompleted(
                            currentTrainingSet: currentTrainingSet!,
                            quantityDone: quantityDone
                        )
                        
                        viewModel.checkIfCycleIsFinished(
                            routine: selectedRoutine!,
                            viewContext: viewContext
                        )
                        
                        viewModel.saveEntry(viewContext: viewContext)
                                                
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
    
}

#Preview{
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest = TrainingSet.fetchRequest()
    
    let trainingSets = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
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
