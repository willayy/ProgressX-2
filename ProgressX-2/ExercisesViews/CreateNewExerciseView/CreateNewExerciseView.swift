//
//  CreateNewExercise2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct CreateNewExerciseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch bodyEntres to get current weight
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: false)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    // Fetch Exercises
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    @StateObject private var viewModel = CreateNewExerciseViewModel()
    
    var body: some View {
        
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Create new exercise")
                
                if viewModel.exerciseCreatedAlert {
                    SubmitAlert(
                        message: "Successfully created new Exercise!",
                        color: .green,
                        showAlertState: $viewModel.exerciseCreatedAlert
                    )
                }
                
                InputTextField(
                    placeHolder: "New exercise name",
                    text: $viewModel.enteredExerciseName,
                    maxChars: 25,
                    markAsWrong: $viewModel.enteredExerciseNameIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.enteredExerciseNameIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                
                InputTextField(
                    placeHolder: "New exercise description",
                    text: $viewModel.enteredExerciseDesc,
                    maxChars: 200,
                    markAsWrong: $viewModel.enteredExerciseDescIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.enteredExerciseDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Exercise type?")
                
                LightSubHeadline(text: "Should the exercise be based on doing an amount of reps or doing an amount of time?")
                    .padding(.horizontal, 30)
                
                BasicSegPicker(
                    selectedSegment: $viewModel.selectedTypeOfExercise,
                    segments: viewModel.exerciseTypeOptions,
                    frameWidth: 230,
                    horizontalPadding: 100
                )
                
                BoldSubHeadline(text: "Add personal record for this exercise?")
                    .padding(.top, 20)
                
                BasicSegPicker(
                    selectedSegment: $viewModel.addPr,
                    segments: viewModel.addPrOptions,
                    frameWidth: 230,
                    horizontalPadding: 100
                )
                    .padding(.bottom)
                
                // MARK: Do you want to add a PR for the new exercise
                if viewModel.addPr == "Yes" {
                    
                    // If rep exercise add segmented picker to chose AMRAP pr or 1RM pr
                    if viewModel.selectedTypeOfExercise == "Reps" {
                        BasicSegPicker(
                            selectedSegment: $viewModel.selectedTypeOfPr,
                            segments: viewModel.repBasedPrOptions,
                            frameWidth: 230,
                            horizontalPadding: 100
                        )
                        .padding(.bottom)
                    }
                    
                    InputDecimalNumberField(
                        placeHolder: "Load (\(weightUnit))", 
                        allowNegatives: false,
                        numberText: $viewModel.enteredPrWeigtLoad,
                        markAsWrong: $viewModel.enteredPrWeigtLoadIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.enteredPrWeigtLoadIsInvalidMsg
                    )
                    
                    if viewModel.selectedTypeOfExercise == "Time" {
                        InputDecimalNumberField(
                            placeHolder: "PR time in seconds", 
                            allowNegatives: false,
                            numberText: $viewModel.enteredPrQuantity,
                            markAsWrong: $viewModel.enteredPrQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.enteredPrQuantityIsInvalidMsg
                        )
                            
                    } else if viewModel.selectedTypeOfExercise == "Reps" && viewModel.selectedTypeOfPr == "AMRAP" {
                        InputIntegerNumberField(
                            placeHolder: "Reps", 
                            allowNegatives: false,
                            numberText: $viewModel.enteredPrQuantity,
                            markAsWrong: $viewModel.enteredPrQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.enteredPrQuantityIsInvalidMsg
                        )
                    }
                }
                
                Button(action: {
                    if validateInput() {
                        viewModel.createNewExercise(viewContext: viewContext)
                    }
                }) {
                    Text("Save new exercise")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
                
            }
        }.onChange(of: viewModel.selectedTypeOfPr, initial: true, {
            viewModel.prTypeChanged(bodyEntries: bodyEntries)
        })
        .onChange(of: viewModel.selectedTypeOfExercise, initial: true, {
            viewModel.exerciseTypeChanged(bodyEntries: bodyEntries)
        })
    }
    
    /// Validates input, marks textfields that are filled incorrectly.
    /// - Returns: True if input is  valid and false if not
    private func validateInput() -> Bool {
        var valid: Int = 0
        
        // Quantity can be either Double or Int
        let quantityFieldValidtor: InputFieldValidator
        
        // Depemnding on the the exercise
        if viewModel.selectedTypeOfExercise == "Reps" {
            quantityFieldValidtor = IntFieldValidator()
        } else {
            // This is the case when exercise is Time
            quantityFieldValidtor = DoubleFieldValidator()
        }

        // Load is a always Double
        let loadFieldValidtor = DoubleFieldValidator()
        let nameFieldValidator = StringFieldValidator(duplicatesAllowed: false, checkStrings: exercises.map {$0.exerciseName!})
        let descFieldValidator = StringFieldValidator(emptyAllowed: true)
        
        valid += nameFieldValidator.valideField(
            inputVar: viewModel.enteredExerciseName,
            errorMessage: $viewModel.enteredExerciseNameIsInvalidMsg ,
            fieldInvalid: $viewModel.enteredExerciseNameIsInvalid
        )
        
        valid += descFieldValidator.valideField(
            inputVar: viewModel.enteredExerciseDesc,
            errorMessage: $viewModel.enteredExerciseDescIsInvalidMsg ,
            fieldInvalid: $viewModel.enteredExerciseDescIsInvalid
        )
        
        if viewModel.addPr == "Yes" {
            valid += loadFieldValidtor.valideField(inputVar: viewModel.enteredPrWeigtLoad, errorMessage: $viewModel.enteredPrWeigtLoadIsInvalidMsg ,fieldInvalid: $viewModel.enteredPrWeigtLoadIsInvalid)
            valid += quantityFieldValidtor.valideField(inputVar: viewModel.enteredPrQuantity, errorMessage: $viewModel.enteredPrQuantityIsInvalidMsg ,fieldInvalid: $viewModel.enteredPrQuantityIsInvalid)
        }
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var lst: [Exercise] = [Exercise()]
    return CreateNewExerciseView()
                .environment(\.managedObjectContext, context)
}

