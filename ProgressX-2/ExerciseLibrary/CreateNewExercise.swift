//
//  CreateNewExercise2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct CreateNewExercise: View {
    
    private let p = PersistenceController.shared
    
    // Dont want to add this but since SwiftUI doesnt notice / refresh view when object attribtues changes i have to.
    @Binding var exercises: [Exercise]
    
    @State private var newExerciseNameWrong: Bool = false
    @State private var selectedTypeOfExercise: String = "Reps"
    @State private var selectedTypeOfRepsPr: String = "1RM"
    @State private var addPr: String = "No"
    @State private var achieviedOnCurrBw: String = "Yes"
    
    // States for the textfields
    @State private var newExerciseName: String = ""
    @State private var newExerciseDesc: String = ""
    @State private var enteredAmrap: String = ""
    @State private var enteredOneRepMax: String = ""
    @State private var enteredTime: String = ""
    @State private var enteredLoad: String = ""
    
    @State private var enteredAmrapIsWrong: Bool = false
    @State private var enteredOneRepMaxIsWrong: Bool = false
    @State private var enteredTimeIsWrong: Bool = false
    @State private var enteredLoadIsWrong: Bool = false
        
    let exerciseTypeOptions: [String] = ["Reps", "Time"]
    let addPrOptions: [String] = ["Yes", "No"]
    let achievedAtBwOptions: [String] = ["Yes", "No"]
    let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    /// Returns the current body weight for the profile using the app
    /// - Returns: A double fetched from the CoreData DB
    private func getCurrBw() -> String {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        let currBw = p.getBodyWeightEntriesAsArray().last!.bodyWeight
        return formatter.string(from: NSNumber(value: currBw))!
    }
    
    private func getCurrBw() -> Double {
        let currBw = p.getBodyWeightEntriesAsArray().last!.bodyWeight
        return currBw
    }
    
    /// Returns the selected unit for the profile using the app
    /// - Returns: A "kg" for metric users and "lbs" for imperial users
    private func getUnit() -> String {
        let unit = p.getProfile()!.isMetric ? "kg" : "lbs"
        return unit
    }
    
    /// Validates input, marks textfields that are filled incorrectly.
    /// - Returns: True if input is  valid and false if not
    private func validateInput() -> Bool {
        
        // Ugly input validation with a lot of if statements, could be better but dont have time to redesign.
        
        // Checks no duplicate exercises can be created
        if (exercises.contains { $0.exerciseName == newExerciseName }) {
            newExerciseNameWrong = true
            return false
        } else {newExerciseNameWrong=false}
        
        // Checks so the new name isnt an empty string
        if newExerciseName.isEmpty {newExerciseNameWrong=true; return false}
        else {newExerciseNameWrong=false}
        
        // Checks so, which ever pr you pressed, the value entered isnt empty.
        if (addPr == "Yes" && selectedTypeOfExercise == "Reps") {
            if (selectedTypeOfRepsPr == "1RM" && enteredOneRepMax.isEmpty) {enteredOneRepMaxIsWrong=true; return false}
            else {enteredOneRepMaxIsWrong=false}
            
            if (selectedTypeOfRepsPr == "AMRAP" && enteredAmrap.isEmpty) {enteredAmrapIsWrong=true; return false}
            else {enteredAmrapIsWrong=false}
        }
        
        else if (addPr == "Yes" && selectedTypeOfExercise == "Time") {
            if (enteredTime.isEmpty) {enteredTimeIsWrong=true; return false}
            else {enteredTimeIsWrong=false}
            
            if (achieviedOnCurrBw == "Yes" && enteredLoad.isEmpty) {enteredLoadIsWrong=true; return false}
            else {enteredLoadIsWrong=false}
        }
        
        return true
    }
    
    /// Adds a PR if the user has filled in that they want it.
    /// - Returns: Void
    private func addPrIfWanted(exercise: Exercise) -> Void {
        if (addPr == "Yes" && selectedTypeOfExercise == "Reps") {
            if selectedTypeOfRepsPr == "1RM" {
                let pr = OneRepMax(context: p.container.viewContext)
                pr.load = Double(enteredOneRepMax)!
                pr.repBasedExercise = (exercise as! RepBasedExercise)
                (exercise as! RepBasedExercise).addToOneRepMaxPrs(pr)
                p.save()
            } else if selectedTypeOfRepsPr == "AMRAP" {
                let pr = MaxReps(context: p.container.viewContext)
                pr.reps = Int64(enteredAmrap)!
                pr.load = (achieviedOnCurrBw == "Yes" ? getCurrBw() : Double(enteredLoad))!
                pr.repBasedExercise = (exercise as! RepBasedExercise)
                (exercise as! RepBasedExercise).addToMaxRepPrs(pr)
                p.save()
            }
        }
        else if (addPr == "Yes" && selectedTypeOfExercise == "Time") {
            let pr = TimeMax(context: p.container.viewContext)
            pr.time = Double(enteredTime)!
            pr.load = (achieviedOnCurrBw == "Yes" ? getCurrBw() : Double(enteredLoad))!
            pr.timeBasedExercise = (exercise as! TimeBasedExercise)
            (exercise as! TimeBasedExercise).addToTimePrs(pr)
            p.save()
        }
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                BoldTitle(text: "Create new exercise")
                
                InputShortTextField(placeHolder: "New exercise name", text: $newExerciseName, markAsWrong: $newExerciseNameWrong, width: 0.6)
                
                TextField("New exercise description", text: $newExerciseDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)

                BoldSubHeadline(text: "Exercise type?")
    
                LightSubHeadline(text: "ProgressX divides up exercises in two broad types, exercises based on how many reps you can do (AMRAP or 1RM, ex Benchpress, Deadlift etc) and exercises based on doing something for a set amount of time (Plank, Cardio etc).")
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
                         + Text("\(getCurrBw()) \(getUnit())")
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
                            
                            InputIntegerNumberField(placeHolder: "AMRAP", numberText: $enteredAmrap, markAsWrong: $enteredAmrapIsWrong, width: 0.6)
                            
                        } else if achieviedOnCurrBw == "No" {
                            
                            BasicSegPicker(selectedSegment: $achieviedOnCurrBw, segments: achievedAtBwOptions, frameWidth: 230, horizontalPadding: 100)
                            
                            LightSubHeadline(text: "Enter the load and the amount of reps performed on your AMRAP pr")
                                .padding(.horizontal, 30)
                                .padding(.top, 10)
                            
                            InputDecimalNumberField(placeHolder: getUnit(), numberText: $enteredLoad, markAsWrong: $enteredLoadIsWrong, width: 0.6)
                            
                            InputIntegerNumberField(placeHolder: "AMRAP", numberText: $enteredAmrap, markAsWrong: $enteredAmrapIsWrong, width: 0.6)
                        }
                        
                    } else if selectedTypeOfRepsPr == "1RM" {
                        
                        LightSubHeadline(text: "Enter your 1RM")
                        
                        InputIntegerNumberField(placeHolder: "1RM", numberText: $enteredOneRepMax, markAsWrong: $enteredAmrapIsWrong, width: 0.6)
                            .padding(.top, 10)
                    }
                
                // MARK: Do you want to add a PR for a time based exercise
                } else if addPr == "Yes" && selectedTypeOfExercise == "Time" {
                    
                    (Text("Was this time record achieved at your current bodyweight of ")
                        .font(.subheadline)
                        .fontWeight(.light)
                     + Text("\(getCurrBw()) \(getUnit())")
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
                        
                        InputDecimalNumberField(placeHolder: "Seconds", numberText: $enteredTime, markAsWrong: $enteredTimeIsWrong, width: 0.6)
                        
                    } else if achieviedOnCurrBw == "No" {
                        
                        LightSubHeadline(text: "Enter the load and the amount of time under tension in seconds")
                            .padding(.horizontal, 30)
                        
                        InputDecimalNumberField(placeHolder: getUnit(), numberText: $enteredLoad, markAsWrong: $enteredLoadIsWrong, width: 0.6)
                        
                        InputDecimalNumberField(placeHolder: "Seconds", numberText: $enteredTime, markAsWrong: $enteredTimeIsWrong, width: 0.6)
                    }
                }
                
                Button(action: {
                    if validateInput() {
                        let context = p.container.viewContext
                        var exercise: Exercise?
                        if selectedTypeOfExercise == "Reps" {exercise = RepBasedExercise(context: context)}
                        if selectedTypeOfExercise == "Time" {exercise = TimeBasedExercise(context: context)}
                        exercise!
                            .setValue_ch(newExerciseName, forKey: "exerciseName")
                            .setValue(newExerciseDesc, forKey: "exerciseDesc")
                        addPrIfWanted(exercise: exercise!)
                        p.save()
                        exercises.append(exercise!)
                        newExerciseName = ""
                        newExerciseDesc = ""
                        selectedTypeOfExercise = "Reps"
                        selectedTypeOfRepsPr = "1RM"
                        addPr = "No"
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
}

#Preview {
    struct Preview: View {
        @State var lst: [Exercise] = [Exercise()]
            var body: some View {
                CreateNewExercise(exercises: $lst)
            }
        }
    return Preview()
}

