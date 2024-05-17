//
//  CreateNewProfile3.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct CreateNewProfile3: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @State var chestCirc = ""
    @State var waistCirc = ""
    @State var thighCirc = ""
    @State var calfCirc = ""
    @State var upperArmCirc = ""
    @State var lowerArmCirc = ""
    
    @State var chestCircIsInvalid = false
    @State var waistCircIsInvalid = false
    @State var thighCircIsInvalid = false
    @State var calfCircIsInvalid = false
    @State var upperArmCircIsInvalid = false
    @State var lowerArmCircIsInvalid = false
    
    @State var benchPress1RM = ""
    @State var squat1RM = ""
    @State var deadLift1RM = ""
    @State var shoulderPress1RM = ""
    
    @State var benchPress1RMIsInvalid = false
    @State var squat1RMIsInvalid = false
    @State var deadLift1RMIsInvalid = false
    @State var shoulderPress1RMIsInvalid = false
    
    @State var pushupsAmrap = ""
    @State var situpsAmrap = ""
    
    @State var situpsAmrapIsInvalid = false
    @State var pushupsAmrapIsInvalid = false
    
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    
    private func validateInput() -> Bool {
        
        var inputIsValid = true
        
        func fieldIsInvalid(_ inputfield: String) -> Bool {
            if inputfield.isEmpty {
                inputIsValid = false
                return true
            } else {
                return false
            }
        }
        
        chestCircIsInvalid = fieldIsInvalid(chestCirc)
        waistCircIsInvalid = fieldIsInvalid(waistCirc)
        thighCircIsInvalid = fieldIsInvalid(thighCirc)
        calfCircIsInvalid = fieldIsInvalid(calfCirc)
        upperArmCircIsInvalid = fieldIsInvalid(upperArmCirc)
        lowerArmCircIsInvalid = fieldIsInvalid(lowerArmCirc)
        
        benchPress1RMIsInvalid = fieldIsInvalid(benchPress1RM)
        squat1RMIsInvalid = fieldIsInvalid(squat1RM)
        deadLift1RMIsInvalid = fieldIsInvalid(deadLift1RM)
        shoulderPress1RMIsInvalid = fieldIsInvalid(shoulderPress1RM)
        
        situpsAmrapIsInvalid = fieldIsInvalid(situpsAmrap)
        pushupsAmrapIsInvalid = fieldIsInvalid(pushupsAmrap)
        
        return inputIsValid
    }
    
    private func addExtraInfo() {
        let p = PersistenceController.shared
        let bwEntries = p.getBodyWeightEntriesAsArray()
        let firstEntry = bwEntries.first
        firstEntry!.chestCirc = Double(chestCirc)!
        firstEntry!.waistCirc = Double(waistCirc)!
        firstEntry!.thighCirc = Double(thighCirc)!
        firstEntry!.calfCirc = Double(calfCirc)!
        firstEntry!.uprArmCirc = Double(upperArmCirc)!
        firstEntry!.lwrArmCirc = Double(lowerArmCirc)!
        
        p.generateBasicExerciseLibrary()
        let exercises = p.getExercisesAsArray()
        let bodyWeight = p.getBodyWeightEntriesAsArray().last!.bodyWeight
        
        // Iterate through basic exercises generated and map the correct values to the correct exercise. Very boilerplaty code, should probably be replaced by something more sophisticated.
        for exercise in exercises {
            switch exercise.exerciseName {
            case "Bench-press":
                OneRepMax(context: p.container.viewContext)
                    .setValue_ch(Double(benchPress1RM), forKey: "load")
                    .repBasedExercise = (exercise as! RepBasedExercise)
            case "Squat":
                OneRepMax(context: p.container.viewContext)
                    .setValue_ch(Double(squat1RM), forKey: "load")
                    .repBasedExercise = (exercise as! RepBasedExercise)
            case "Deadlift":
                OneRepMax(context: p.container.viewContext)
                    .setValue_ch(Double(deadLift1RM), forKey: "load")
                    .repBasedExercise = (exercise as! RepBasedExercise)
            case "Shoulder-press":
                OneRepMax(context: p.container.viewContext)
                    .setValue_ch(Double(shoulderPress1RM), forKey: "load")
                    .repBasedExercise = (exercise as! RepBasedExercise)
            case "Sit-up":
                MaxReps(context: p.container.viewContext)
                    .setValue_ch(bodyWeight, forKey: "load")
                    .setValue_ch(Int64(situpsAmrap), forKey: "reps")
                    .repBasedExercise = (exercise as! RepBasedExercise)
            case "Push-up":
                MaxReps(context: p.container.viewContext)
                    .setValue_ch(bodyWeight, forKey: "load")
                    .setValue_ch(Int64(pushupsAmrap), forKey: "reps")
                    .repBasedExercise = (exercise as! RepBasedExercise)
            default:
                continue
            }
        }
        p.save()
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(minScaleFactor);
                
                Text("Pleasse fill in all the following fields")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(minScaleFactor);
                
                let circumferenceUnit: String = (PersistenceController.shared.getProfile()!.isMetric) ? "cm" : "ft"
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Circumference metrics")
                        .font(.headline)
                    
                    HStack() {
                        Text("Chest circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $chestCirc, markAsWrong: $chestCircIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Waist circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $waistCirc, markAsWrong: $waistCircIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Thigh circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $thighCirc, markAsWrong: $thighCircIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Calf circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $calfCirc, markAsWrong: $calfCircIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Lower arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $lowerArmCirc, markAsWrong: $lowerArmCircIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Upper arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 200)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $upperArmCirc, markAsWrong: $upperArmCircIsInvalid, width: inputFieldWidth)
                    }
                    
                }
                .padding(.top, 40)
                
                let oneRepMaxUnit: String = (PersistenceController.shared.getProfile()!.isMetric) ? "kg" : "lbs"
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("One rep max's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Benchpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 120)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $benchPress1RM, markAsWrong: $benchPress1RMIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Squats")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 120)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $squat1RM, markAsWrong: $squat1RMIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Shoulderpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 120)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $shoulderPress1RM, markAsWrong: $shoulderPress1RMIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Deadlift")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 120)
                        InputDecimalNumberField(placeHolder: oneRepMaxUnit, numberText: $deadLift1RM, markAsWrong: $deadLift1RMIsInvalid, width: inputFieldWidth)
                    }
                }
                .padding(.top, 40)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("AMRAP's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Pushups")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 120)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $pushupsAmrap, markAsWrong: $pushupsAmrapIsInvalid, width: inputFieldWidth)
                    }
                    HStack() {
                        Text("Situps")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 120)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $situpsAmrap, markAsWrong: $situpsAmrapIsInvalid, width: inputFieldWidth)
                    }
                }
                .padding(.top, 40)
                
                Button {
                    if validateInput() {
                        addExtraInfo()
                        viewRouter.rootView = "HomeView"
                    }
                } label: {
                    Text("Finish")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 40)
                
            }
        }
    }
}

#Preview {
    CreateNewProfile3()
        .environmentObject(ViewRouter())
}
