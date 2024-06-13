//
//  CreateNewExercise2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct CreateNewExerciseView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch the Profile to se if its metric or not
    @FetchRequest(
        entity: Profile.entity(),
        sortDescriptors: []
    ) private var profileResults: FetchedResults<Profile>
    
    // Fetch bodyEntres to get current weight
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.dateAchieved, ascending: false)]
    ) private var bodyEntryResults: FetchedResults<BodyEntry>
    
    // Fetch RepBasedExercises to check if exercise name is taken
    @FetchRequest(
        entity: RepBasedExercise.entity(),
        sortDescriptors: []
    ) private var repBasedExerciseResults: FetchedResults<Exercise>
    
    // Fetch TimeBasedExercises to check if exercise name is taken
    @FetchRequest(
        entity: TimeBasedExercise.entity(),
        sortDescriptors: []
    ) private var timeBasedExerciseResults: FetchedResults<Exercise>
    
    @State private var currBw: Double = 0
    @State private var selectedExerciseName: String = ""
    @State private var selectedExerciseDesc: String = ""
    @State private var enteredAmrap: String = ""
    @State private var enteredOneRepMax: String = ""
    @State private var enteredTime: String = ""
    @State private var enteredLoad: String = ""
    @State private var createdExerciseName: String = ""
    @State private var selectedTypeOfExercise: String = "Reps"
    @State private var selectedTypeOfRepsPr: String = "1RM"
    @State private var addPr: String = "No"
    @State private var achieviedOnCurrBw: String = "Yes"
    @State private var exerciseCreatedAlert: Bool = false
    @State private var newExerciseNameWrong: Bool = false
    @State private var enteredAmrapIsWrong: Bool = false
    @State private var enteredOneRepMaxIsWrong: Bool = false
    @State private var enteredTimeIsWrong: Bool = false
    @State private var enteredLoadIsWrong: Bool = false
    @State private var exerciseResults: [Exercise] = []
    private let exerciseTypeOptions: [String] = ["Reps", "Time"]
    private let addPrOptions: [String] = ["Yes", "No"]
    private let achievedAtBwOptions: [String] = ["Yes", "No"]
    private let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    var body: some View {
        
        let weightUnit = profileResults.first!.isMetric ? "kg" : "lbs"
        
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Create new exercise")
                
                if exerciseCreatedAlert {
                    showExerciseCreatedAlert()
                }
                
                InputShortTextField(placeHolder: "New exercise name", text: $selectedExerciseName, markAsWrong: $newExerciseNameWrong, width: 0.6, errorMessage: "This name is invalid or taken!")
                
                TextField("New exercise description", text: $selectedExerciseDesc)
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
                
                // MARK: Do you want to add a PR for a rep based exercise
                if addPr == "Yes" && selectedTypeOfExercise == "Reps" {
                        
                    LightSubHeadline(text: "AMRAP pr or 1RM pr?")
                            .padding(.top, 10)
                    
                    BasicSegPicker(selectedSegment: $selectedTypeOfRepsPr, segments: repBasedPrOptions, frameWidth: 230, horizontalPadding: 100)
                    
                    if selectedTypeOfRepsPr == "AMRAP" {
                        
                        (Text("Was this time record achieved at your current bodyweight of ")
                            .font(.subheadline)
                            .fontWeight(.light)
                         + Text("\(currBw) \(weightUnit)")
                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 25)
                            .minimumScaleFactor(0.5)
                            .padding(.horizontal, 30)
                            .padding(.top, 10)
                        
                        if achieviedOnCurrBw == "Yes" {
                            
                            BasicSegPicker(selectedSegment: $achieviedOnCurrBw, segments: achievedAtBwOptions, frameWidth: 230, horizontalPadding: 100)
                            
                            LightSubHeadline(text: "Enter the amount of reps performed on your AMRAP pr")
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                            
                            InputIntegerNumberField(placeHolder: "AMRAP", numberText: $enteredAmrap, markAsWrong: $enteredAmrapIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                            
                        } else if achieviedOnCurrBw == "No" {
                            
                            BasicSegPicker(selectedSegment: $achieviedOnCurrBw, segments: achievedAtBwOptions, frameWidth: 230, horizontalPadding: 100)
                            
                            LightSubHeadline(text: "Enter the load and the amount of reps performed on your AMRAP pr")
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                            
                            InputDecimalNumberField(placeHolder: weightUnit, numberText: $enteredLoad, markAsWrong: $enteredLoadIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                            
                            InputIntegerNumberField(placeHolder: "AMRAP", numberText: $enteredAmrap, markAsWrong: $enteredAmrapIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                        }
                        
                    } else if selectedTypeOfRepsPr == "1RM" {
                        
                        LightSubHeadline(text: "Enter your 1RM")
                            .padding(.top, 10)
                        
                        InputIntegerNumberField(placeHolder: "1RM", numberText: $enteredOneRepMax, markAsWrong: $enteredAmrapIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                            
                    }
                
                // MARK: Do you want to add a PR for a time based exercise
                } else if addPr == "Yes" && selectedTypeOfExercise == "Time" {
                    
                    (Text("Was this time record achieved at your current bodyweight of ")
                        .font(.subheadline)
                        .fontWeight(.light)
                     + Text("\(currBw) \(weightUnit)")
                        .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/))
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 25)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 10)
                    
                    BasicSegPicker(selectedSegment: $achieviedOnCurrBw, segments: achievedAtBwOptions, frameWidth: 230, horizontalPadding: 100)
                    
                    if achieviedOnCurrBw == "Yes" {
                        
                        LightSubHeadline(text: "Enter amount of time under tension in seconds")
                            .padding(.horizontal, 30)
                        
                        InputDecimalNumberField(placeHolder: "Seconds", numberText: $enteredTime, markAsWrong: $enteredTimeIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                        
                    } else if achieviedOnCurrBw == "No" {
                        
                        LightSubHeadline(text: "Enter the load and the amount of time under tension in seconds")
                            .padding(.horizontal, 30)
                        
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $enteredLoad, markAsWrong: $enteredLoadIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                        
                        InputDecimalNumberField(placeHolder: "Seconds", numberText: $enteredTime, markAsWrong: $enteredTimeIsWrong, width: 0.6, errorMessage: "This cant be left empty!")
                    }
                }
                
                Button(action: {
                    if validateInput() {
                        var exercise: Exercise?
                        if selectedTypeOfExercise == "Reps" {exercise = RepBasedExercise(context: viewContext)}
                        if selectedTypeOfExercise == "Time" {exercise = TimeBasedExercise(context: viewContext)}
                        exercise!
                            .setValue_ch(selectedExerciseName, forKey: "exerciseName")
                            .setValue(selectedExerciseDesc, forKey: "exerciseDesc")
                        addPrIfWanted(exercise: exercise!)
                        PersistenceController.save(viewContext)
                        createdExerciseName = selectedExerciseName
                        selectedExerciseName = ""
                        selectedExerciseDesc = ""
                        selectedTypeOfExercise = "Reps"
                        selectedTypeOfRepsPr = "1RM"
                        addPr = "No"
                        withAnimation {
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
        }.onAppear(perform: {
            exerciseResults.append(contentsOf: repBasedExerciseResults)
            exerciseResults.append(contentsOf: timeBasedExerciseResults)
            currBw = bodyEntryResults.first!.bodyWeight
        })
    }
    
    /// Validates input, marks textfields that are filled incorrectly.
    /// - Returns: True if input is  valid and false if not
    private func validateInput() -> Bool {
        
        // Ugly input validation with a lot of if statements, could be better but dont have time to redesign.
        
        // Checks no duplicate exercises can be created
        if (exerciseResults.contains {
            $0.exerciseName == selectedExerciseName
        }) {
            withAnimation{newExerciseNameWrong = true}
            return false
        } else {
            withAnimation{newExerciseNameWrong=false}
        }
        
        // Checks so the new name isnt an empty string
        if selectedExerciseName.isEmpty {
            withAnimation{newExerciseNameWrong=true}
            return false}
        else {
            withAnimation{newExerciseNameWrong=false}
        }
        
        // Checks so, which ever pr you pressed, the value entered isnt empty.
        if (addPr == "Yes" && selectedTypeOfExercise == "Reps") {
            if (selectedTypeOfRepsPr == "1RM" && enteredOneRepMax.isEmpty) {
                withAnimation{enteredOneRepMaxIsWrong=true}
                return false
            } else {
                withAnimation{enteredOneRepMaxIsWrong=false}
            }
            
            if (selectedTypeOfRepsPr == "AMRAP" && enteredAmrap.isEmpty) {
                withAnimation{enteredAmrapIsWrong=true}
                return false
            }
            else {
                withAnimation{enteredAmrapIsWrong=false}
            }
        }
        
        else if (addPr == "Yes" && selectedTypeOfExercise == "Time") {
            if (enteredTime.isEmpty) {
                withAnimation{enteredTimeIsWrong=true}
                return false
            }
            else {
                withAnimation{enteredTimeIsWrong=false}
            }
            
            if (achieviedOnCurrBw == "Yes" && enteredLoad.isEmpty) {
                withAnimation{enteredLoadIsWrong=true}
                return false
            }
            else {
                withAnimation{enteredLoadIsWrong=false}
            }
        }
        
        return true
    }

    /// Adds a PR if the user has filled in that they want it.
    /// - Returns: Void
    private func addPrIfWanted(exercise: Exercise) -> Void {
        if (addPr == "Yes" && selectedTypeOfExercise == "Reps") {
            if selectedTypeOfRepsPr == "1RM" {
                let pr = OneRepMax(context: viewContext)
                pr.weightLoad = Double(enteredOneRepMax)!
                pr.exercise = (exercise as! RepBasedExercise)
                pr.achievedOnDate = Date()
                (exercise as! RepBasedExercise).addToPersonalRecords(pr)
                PersistenceController.save(viewContext)
            } else if selectedTypeOfRepsPr == "AMRAP" {
                let pr = MaxReps(context: viewContext)
                pr.prQuantity = Double(enteredAmrap)!
                pr.weightLoad = (achieviedOnCurrBw == "Yes" ? currBw : Double(enteredLoad))!
                pr.exercise = (exercise as! RepBasedExercise)
                pr.achievedOnDate = Date()
                (exercise as! RepBasedExercise).addToPersonalRecords(pr)
                PersistenceController.save(viewContext)
            }
        }
        else if (addPr == "Yes" && selectedTypeOfExercise == "Time") {
            let pr = TimeMax(context: viewContext)
            pr.prQuantity = Double(enteredTime)!
            pr.weightLoad = (achieviedOnCurrBw == "Yes" ? currBw : Double(enteredLoad))!
            pr.exercise = (exercise as! TimeBasedExercise)
            pr.achievedOnDate = Date()
            (exercise as! TimeBasedExercise).addToPersonalRecords(pr)
            PersistenceController.save(viewContext)
        }
    }

    /// Shows an alert that an exercise has been created
    /// - Returns: some View
    private func showExerciseCreatedAlert() -> some View {
        Text("Succesfully created exercise called \(createdExerciseName)")
            .fontWeight(.light)
            .foregroundStyle(.green)
            .padding(.bottom, 10)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        exerciseCreatedAlert = false
                        createdExerciseName = ""
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

