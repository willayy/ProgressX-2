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
    
    @State private var currBw: Double = 0
    @State private var enteredExerciseName: String = ""
    @State private var enteredExerciseDesc: String = ""
    @State private var enteredPrQuantity: String = ""
    @State private var enteredPrWeigtLoad: String = ""
    
    // Segment picker choices
    @State private var selectedTypeOfExercise: String = "Reps"
    @State private var selectedTypeOfPr: String = "1RM"
    @State private var addPr: String = "No"
    @State private var achieviedOnCurrBw: String = "Yes"
    
    // Pop-up alert
    @State private var exerciseCreatedAlert: Bool = false
    
    // Input field vars
    @State private var enteredExerciseNameIsInvalid: Bool = false
    @State private var enteredExerciseDescIsInvalid: Bool = false
    @State private var enteredPrQuantityIsInvalid: Bool = false
    @State private var enteredPrWeigtLoadIsInvalid: Bool = false
    
    @State private var enteredExerciseNameIsInvalidMsg: String = ""
    @State private var enteredExerciseDescIsInvalidMsg: String = ""
    @State private var enteredPrQuantityIsInvalidMsg: String = ""
    @State private var enteredPrWeigtLoadIsInvalidMsg: String = ""
    
    // Segment picker options
    private let exerciseTypeOptions: [String] = ["Reps", "Time"]
    private let addPrOptions: [String] = ["Yes", "No"]
    private let achievedAtBwOptions: [String] = ["Yes", "No"]
    private let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    var body: some View {
        
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Create new exercise")
                
                if exerciseCreatedAlert {
                    showExerciseCreatedAlert()
                }
                
                InputShortTextField(placeHolder: "New exercise name", text: $enteredExerciseName, markAsWrong: $enteredExerciseNameIsInvalid, width: 0.6, errorMessage: $enteredExerciseNameIsInvalidMsg)
                
                TextField("New exercise description", text: $enteredExerciseDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)
                
                BoldSubHeadline(text: "Exercise type?")
                
                LightSubHeadline(text: "Should the exercise be based on doing an amount of reps or doing an amount of time?")
                    .padding(.horizontal, 30)
                
                BasicSegPicker(selectedSegment: $selectedTypeOfExercise, segments: exerciseTypeOptions, frameWidth: 230, horizontalPadding: 100)
                
                BoldSubHeadline(text: "Add personal record for this exercise?")
                    .padding(.top, 20)
                
                BasicSegPicker(selectedSegment: $addPr, segments: addPrOptions, frameWidth: 230, horizontalPadding: 100)
                
                // MARK: Do you want to add a PR for the new exercise
                if addPr == "Yes" {
                    
                    // If rep exercise add segmented picker to chose AMRAP pr or 1RM pr
                    if selectedTypeOfExercise == "Reps" {
                        BasicSegPicker(selectedSegment: $selectedTypeOfPr, segments: repBasedPrOptions, frameWidth: 230, horizontalPadding: 100)
                    }
                    
                    InputDecimalNumberField(placeHolder: "Load (\(weightUnit))", numberText: $enteredPrWeigtLoad, markAsWrong: $enteredPrWeigtLoadIsInvalid, width: 0.6, errorMessage: $enteredPrWeigtLoadIsInvalidMsg)
                        .onAppear {
                            if (selectedTypeOfPr == "AMRAP" || selectedTypeOfExercise == "Time") {
                                enteredPrWeigtLoad = String(bodyEntries.first!.bodyWeight)
                            }
                            // If time exercise set selectedTypeOfPr to timemax
                            if (selectedTypeOfExercise == "Time") {
                                selectedTypeOfPr = "Time-Max"
                            }
                        }
                    
                    if selectedTypeOfExercise == "Time" {
                        InputDecimalNumberField(placeHolder: "Pr time in seconds", numberText: $enteredPrQuantity, markAsWrong: $enteredPrQuantityIsInvalid, width: 0.6, errorMessage: $enteredPrQuantityIsInvalidMsg)
                            
                    } else if selectedTypeOfExercise == "Reps" {
                        InputIntegerNumberField(placeHolder: "Reps", numberText: $enteredPrQuantity, markAsWrong: $enteredPrQuantityIsInvalid, width: 0.6, errorMessage: $enteredPrQuantityIsInvalidMsg)
                    }
                    
                }
                
                Button(action: {
                    if validateInput() {
                        // Create the new exercise
                        let exercise: Exercise = Exercise(context: viewContext)
                        exercise.exerciseType = selectedTypeOfExercise == "Reps" ? "reps" : "time"
                        exercise.exerciseName = enteredExerciseName
                        exercise.exerciseDesc = enteredExerciseDesc
                        
                        // Add pr if selected
                        if addPr == "Yes" {
                            // Find the pr-type from the user selected value
                            let prType: String
                            switch selectedTypeOfPr {
                            case "AMRAP":
                                prType = "maxreps"
                            case "1RM":
                                prType = "onerepmax"
                            case "Time-max":
                                prType = "timemax"
                            default:
                                prType = "" // This should never be the case
                            }
                            
                            _ = PersistenceController.createPersonalRecord(
                                viewContext,
                                exercise: exercise,
                                wl: Double(enteredPrWeigtLoad)!,
                                q: Double(enteredPrQuantity)!,
                                date: Date(),
                                type: prType
                            )
                        }
                        
                        PersistenceController.save(viewContext)
                        
                        // Reset the selected values
                        withAnimation(.easeOut) {
                            enteredExerciseName = ""
                            enteredExerciseDesc = ""
                            selectedTypeOfExercise = "Reps"
                            selectedTypeOfPr = "1RM"
                            addPr = "No"
                            exerciseCreatedAlert = true
                        }
                    }
                }) {
                    Text("Save new exercise")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                
            }
        }
    }
    
    /// Validates input, marks textfields that are filled incorrectly.
    /// - Returns: True if input is  valid and false if not
    private func validateInput() -> Bool {
        var valid: Bool = true
        
        // Special case for already taken names
        valid = {
            if (exercises.contains { $0.exerciseName == enteredExerciseName }) {
                enteredExerciseNameIsInvalid = true
                enteredExerciseNameIsInvalidMsg = "This Exercise name is already taken!"
                return false
            } else {
                enteredExerciseNameIsInvalid = false
                enteredExerciseNameIsInvalidMsg = ""
                return true
            }
        }()
        
        let doubleFieldValidator = DoubleFieldValidator()
        let stringFieldValidator = StringFieldValidator()
        valid = stringFieldValidator.valideField(inputVar: enteredExerciseName, errorMessage: $enteredExerciseNameIsInvalidMsg ,fieldInvalid: $enteredExerciseNameIsInvalid)
        valid = stringFieldValidator.valideField(inputVar: enteredExerciseDesc, errorMessage: $enteredExerciseDescIsInvalidMsg ,fieldInvalid: $enteredExerciseDescIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: enteredPrWeigtLoad, errorMessage: $enteredPrWeigtLoadIsInvalidMsg ,fieldInvalid: $enteredPrWeigtLoadIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: enteredPrQuantity, errorMessage: $enteredPrQuantityIsInvalidMsg ,fieldInvalid: $enteredPrQuantityIsInvalid)
        return valid
    }
    
    /// Shows an alert that an exercise has been created
    /// - Returns: some View
    private func showExerciseCreatedAlert() -> some View {
        Text("Succesfully created exercise called \(enteredExerciseName)")
            .fontWeight(.light)
            .foregroundStyle(.green)
            .padding(.bottom, 10)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        exerciseCreatedAlert = false
                        enteredExerciseName = ""
                    }
                }
            }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    @State var lst: [Exercise] = [Exercise()]
    return CreateNewExerciseView()
                .environment(\.managedObjectContext, context)
}

