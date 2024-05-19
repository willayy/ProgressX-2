//
//  CreateNewExercise2.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-05-16.
//

import SwiftUI

struct CreateNewExercise: View {
    
    private let p = PersistenceController.shared
    
    @State private var newName: String = ""
    @State private var newDesc: String = ""
    @State private var newExerciseNameWrong: Bool = false
    @State private var selectedType = "Reps"
    @State private var selectedPrType = "AMRAP"
    @State private var addPr = "No"
    @State private var achieviedOnCurrBw = "Yes"
    
    // States for the textfields
    @State private var amrap = ""
    @State private var oneRepMax = ""
    @State private var time = ""
    @State private var load = ""
    
    @State private var amrapIsWrong = false
    @State private var oneRepMaxIsWrong = false
    @State private var timeIsWrong = false
    @State private var loadIsWrong = false
        
    let typeOptions = ["Reps", "Time"]
    let addPrOptions = ["Yes", "No"]
    let achievedAtBwOptions = ["Yes", "No"]
    let prOptions = ["AMRAP", "1RM"]
    
    /// Validates input, marks textfields that are filled incorrectly.
    /// - Returns: True if input is  valid and false if not
    private func validateInput() -> Bool {
        // TODO: Implement
        return false
    }
    
    /// Adds a PR if the user has filled in that they want it.
    /// - Returns: Void
    private func addPrIfWanted() -> Void {
        // TODO: Implement
    }
    
    var body: some View {
        ScrollView {
            VStack {
                
                BoldTitle(text: "Create new exercise")
                
                InputShortTextField(placeHolder: "New exercise name", text: $newName, markAsWrong: $newExerciseNameWrong, width: 0.6)
                
                TextField("New exercise description", text: $newDesc)
                    .frame(width: UIScreen.main.bounds.width * 0.6, height: 50)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom)

                BoldSubHeadline(text: "Exercise type?")
    
                LightSubHeadline(text: "ProgressX divides up exercises in two broad types, exercises based on how many reps you can do (AMRAP or 1RM, ex Benchpress, Deadlift etc) and exercises based on doing something for a set amount of time (Plank, Cardio etc).")
                    .padding(.horizontal, 30)
                
                BasicSegPicker(selectedSegment: $selectedType, segments: typeOptions, frameWidth: 230, horizontalPadding: 100)
                
                BoldSubHeadline(text: "Add personal record for this exercise?")
                    .padding(.top, 20)
                
                BasicSegPicker(selectedSegment: $addPr, segments: addPrOptions, frameWidth: 230, horizontalPadding: 100)
                    .padding(.top, 10)
                
                // MARK: Do you want to add a PR for a rep based exercise
                if addPr == "Yes" && selectedType == "Reps" {
                    
                    LightSubHeadline(text: "AMRAP pr or 1RM pr?")
                    
                    BasicSegPicker(selectedSegment: $selectedPrType, segments: prOptions, frameWidth: 230, horizontalPadding: 100)
                        .padding(.top, 10)
                    
                    if selectedPrType == "AMRAP" {
                        
                        LightSubHeadline(text: "Enter your AMRAP")
                        
                        InputIntegerNumberField(placeHolder: "AMRAP", numberText: $amrap, markAsWrong: $amrapIsWrong, width: 0.6)
                            .padding(.top, 10)
                        
                    } else if selectedPrType == "1RM" {
                        
                        LightSubHeadline(text: "Enter your 1RM")
                        
                        InputIntegerNumberField(placeHolder: "1RM", numberText: $amrap, markAsWrong: $amrapIsWrong, width: 0.6)
                            .padding(.top, 10)
                    }
                
                // MARK: Do you want to add a PR for a time based exercise
                } else if addPr == "Yes" && selectedType == "Time" {
                    
                    LightSubHeadline(text: "Was this time record achieved at your current bodyweight?")
                    
                    BasicSegPicker(selectedSegment: $achieviedOnCurrBw, segments: achievedAtBwOptions, frameWidth: 230, horizontalPadding: 100)
                    
                    if achieviedOnCurrBw == "Yes" {
                        
                        LightSubHeadline(text: "Enter amount of time under tension in seconds")
                        
                        InputDecimalNumberField(placeHolder: "Seconds", numberText: $time, markAsWrong: $timeIsWrong, width: 0.6)
                        
                    } else if achieviedOnCurrBw == "No" {
                        
                        LightSubHeadline(text: "Enter the load and the amount of time under tension in seconds")
                        
                        let unit = p.getProfile()!.isMetric ? "kg" : "lbs"
                        
                        InputDecimalNumberField(placeHolder: unit, numberText: $load, markAsWrong: $loadIsWrong, width: 0.6)
                        
                        InputDecimalNumberField(placeHolder: "Seconds", numberText: $time, markAsWrong: $timeIsWrong, width: 0.6)
                    }
                }
                
                Button(action: {
                    if validateInput() {
                        addPrIfWanted()
                        p.save()
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
            var body: some View {
                CreateNewExercise()
            }
        }
    return Preview()
}

