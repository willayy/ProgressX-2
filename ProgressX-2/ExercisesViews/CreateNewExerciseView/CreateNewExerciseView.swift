//
//  CreateNewExercise2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct CreateNewExerciseView: View {
    
    // Fetch Exercises
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    // All categories that can be selected
    @FetchRequest(
        entity: ExerciseCategory.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \ExerciseCategory.categoryName, ascending: false)]
    ) private var categories: FetchedResults<ExerciseCategory>
        
    @StateObject private var viewModel = CreateNewExerciseViewModel()
    @Environment(\.managedObjectContext) private var viewContext
    @Binding public var navPath: [Int]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Create new exercise")
                    .padding(.horizontal, 20)
                
                BoldSubHeadline(text: "Exercise name")
                    .padding(.top, 10)
                
                InputTextField(
                    placeHolder: "Exercise name",
                    text: $viewModel.enteredExerciseName,
                    markAsWrong: $viewModel.enteredExerciseNameIsInvalid,
                    errorMessage: $viewModel.enteredExerciseNameIsInvalidMsg,
                    maxChars: 25
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Exercise description")
                
                inputLongTextField(
                    placeHolder: "Exercise description",
                    text: $viewModel.enteredExerciseDesc,
                    markAsWrong: $viewModel.enteredExerciseDescIsInvalid,
                    errorMessage: $viewModel.enteredExerciseDescIsInvalidMsg,
                    maxChars: 200
                )
                .frame(height: 150)
                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Exercise type")
                
                HiddenLightSubHeadline(
                    title: "What does exercise type mean?",
                    text: "There are two types of exercises in ProgressX, time based exercise and rep based exercises. Time based exercises are exercises which you do a certain amount of time on, like static holds or the \"Plank\". Rep based exercsies are exercises where you do a certain amount of repetitions, like bench press or squats.",
                    alignment: .leading
                )
                .padding(.horizontal, 30)
                
                BasicSegPicker(
                    selectedSegment: $viewModel.selectedTypeOfExercise,
                    segments: viewModel.exerciseTypeOptions
                )
                .padding(.horizontal, 100)
                
                BoldSubHeadline(text: "Add PR for this exercise?")
                    .padding(.top, 20)
                
                HiddenLightSubHeadline(
                    title: "What are PR's?",
                    text: "A PR (personal record) is a dated record of how you performed on an exercise. For rep based exercises the available PR's are AMRAP (As many reps as possible) and 1RM (one rep max). For time based exercise there is only Time-max PR's which is like an AMRAP PR but instead of counting the reps you did it counts the time you did.",
                    alignment: .leading
                )
                .padding(.horizontal, 40)
                
                BooleanSegPicker(
                    selectedSegment: $viewModel.addPr,
                    segments: viewModel.addPrOptions
                )
                .padding(.horizontal, 100)
                .padding(.bottom, 5)
                
                // MARK: Do you want to add a PR for the new exercise
                if viewModel.addPr == "Yes" {
                    
                    // If rep exercise add segmented picker to chose AMRAP pr or 1RM pr
                    if viewModel.selectedTypeOfExercise == "Rep based" {
                        
                        BasicSegPicker(
                            selectedSegment: $viewModel.selectedTypeOfPr,
                            segments: viewModel.repBasedPrOptions
                        )
                        .padding(.horizontal, 100)
                        .padding(.bottom, 5)
                        
                    }
                    
                    DecimalTextField(
                        placeHolder: "Load (\(viewModel.weightUnit(viewContext: viewContext))",
                        numberText: $viewModel.enteredPrWeigtLoad,
                        markAsWrong: $viewModel.enteredPrWeigtLoadIsInvalid,
                        errorMessage: $viewModel.enteredPrWeigtLoadIsInvalidMsg,
                        bodyWeightButton: true
                    )
                    .padding(.horizontal, 60)

                    if viewModel.selectedTypeOfExercise == "Time based" {
                        
                        DecimalTextField(
                            placeHolder: "PR time in seconds", 
                            numberText: $viewModel.enteredPrQuantity,
                            markAsWrong: $viewModel.enteredPrQuantityIsInvalid,
                            errorMessage: $viewModel.enteredPrQuantityIsInvalidMsg
                        )
                        .padding(.horizontal, 60)
                        
                    } else if viewModel.selectedTypeOfExercise == "Rep based" && viewModel.selectedTypeOfPr == "AMRAP" {
                        
                        IntegerTextField(
                            placeHolder: "Reps", 
                            numberText: $viewModel.enteredPrQuantity,
                            markAsWrong: $viewModel.enteredPrQuantityIsInvalid,
                            errorMessage: $viewModel.enteredPrQuantityIsInvalidMsg
                        )
                        .padding(.horizontal, 60)
                        
                    }
                }
                
                BoldSubHeadline(text: "Add muscle categories to this exercise?")
                    .padding(.top, 15)
                
                SelectCategoriesList(
                    selectedCategories: $viewModel.selectedCategories,
                    categories: _categories
                )
                .padding(.horizontal, 40)
                
                Button(action: {
                    
                    if validateInput() {
                        
                        viewModel.saveEntry(viewContext: viewContext)
                        navPath.removeLast()
                        
                    }
                    
                }) {
                    
                    Text("Create new exercise")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                    
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if viewModel.savingError {
                    
                    SavingErrorText()
                        .padding(.horizontal, 20)
                    
                }
                
            }
        }
        .onChange(of: viewModel.selectedTypeOfPr, initial: true, {
            viewModel.prTypeChanged()
        })
        .onChange(of: viewModel.selectedTypeOfExercise, initial: true, {
            viewModel.exerciseTypeChanged()
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
            quantityFieldValidtor = IntFieldValidator(maxInputNumber: 100000)
        } else {
            // This is the case when exercise is Time
            quantityFieldValidtor = DoubleFieldValidator(maxInputNumber: 100000)
        }

        // Load is a always Double
        let loadFieldValidtor = DoubleFieldValidator(maxInputNumber: 10000)
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
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewExerciseView(
                navPath: $navPath
            )
            .environment(\.managedObjectContext, context)
}

