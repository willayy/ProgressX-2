//
//  CreateNewPersonalRecord.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import SwiftUI
import CoreData

struct CreateNewPersonalRecord: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch bodyEntres to get current weight
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: false)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    // The selection of the segmented picker
    @Binding var prType: String?
    @Binding var navPath: [Int]
    // Exercise for the PR
    @Binding var selectedExercise: Exercise?
    @StateObject private var viewModel = CreateNewPersonalRecordViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                BoldTitle(
                    text: "Create a new PR for exercise: \(selectedExercise!.exerciseName!)"
                )
                .padding(.bottom, 20)
                .padding(.horizontal, 20)
                
                if viewModel.createdPrAlert {
                    SubmitAlert(
                        message: "Succesfully created new PR!",
                        color: .green,
                        showAlertState: $viewModel.createdPrAlert
                    )
                }
                
                LightSubHeadline(text: "Choose a date for the PR")
                
                DatePicker("", selection: $viewModel.prDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 20)
                
                InputDecimalNumberField(
                    placeHolder: "Load", 
                    allowNegatives: false,
                    numberText: $viewModel.prLoad,
                    markAsWrong: $viewModel.prLoadIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.prLoadIsInvalidMsg
                )
                .padding(.bottom, 10)
                .onAppear(perform: {
                    if prType == "onerepmax" {
                        viewModel.prQuantity = "1"
                    }
                })
                    
                if prType == "maxreps" {
                    InputIntegerNumberField(
                        placeHolder: "Reps", 
                        allowNegatives: false,
                        numberText: $viewModel.prQuantity,
                        markAsWrong: $viewModel.prQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.prQuantityIsInvalidMsg
                    )
                }
                
                else if prType == "timemax" {
                    InputDecimalNumberField(
                        placeHolder: "Seconds", 
                        allowNegatives: false,
                        numberText: $viewModel.prQuantity,
                        markAsWrong: $viewModel.prQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.prQuantityIsInvalidMsg
                    )
                }
                
                // MARK: Handle the creation of a PR
                Button(action: {
                    if validateInput() {
                        viewModel.createNewPersonalRecord(
                            viewContext: viewContext,
                            exercise: selectedExercise,
                            prType: prType
                        )
                        navPath.removeLast()
                    }
                }) {
                    Text("Create new PR")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .padding(.top, 20)
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.bottom, 10)
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        
        var valid: Int = 0
        
        var quantityValidator: InputFieldValidator
        
        let loadValidator: InputFieldValidator = DoubleFieldValidator()
        
        if prType == "timemax" {
            quantityValidator = DoubleFieldValidator()
        } else {
            quantityValidator = IntFieldValidator()
        }
        
        valid += loadValidator.valideField(
            inputVar: viewModel.prLoad,
            errorMessage: $viewModel.prLoadIsInvalidMsg,
            fieldInvalid: $viewModel.prLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: viewModel.prQuantity,
            errorMessage: $viewModel.prQuantityIsInvalidMsg,
            fieldInvalid: $viewModel.prQuantityIsInvalid
        )
        
        
        return valid == 0
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestRepBasedExercise.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var prType: String? = "onerepmax"
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewPersonalRecord(
        prType: $prType,
        navPath: $navPath,
        selectedExercise: $exercise
    )
}
