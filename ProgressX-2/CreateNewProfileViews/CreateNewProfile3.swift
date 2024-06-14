//
//  CreateNewProfile3.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct CreateNewProfile3: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch BodyEntries to use as weightLoad in AMRAP prs
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    // Inputfield value states
    @State var chestCirc = ""
    @State var waistCirc = ""
    @State var thighCirc = ""
    @State var calfCirc = ""
    @State var upperArmCirc = ""
    @State var lowerArmCirc = ""
    @State var benchPress1RM = ""
    @State var squat1RM = ""
    @State var deadLift1RM = ""
    @State var shoulderPress1RM = ""
    @State var pushupsAmrap = ""
    @State var situpsAmrap = ""
    
    // Inputfield invalid states
    @State var chestCircIsInvalid = false
    @State var waistCircIsInvalid = false
    @State var thighCircIsInvalid = false
    @State var calfCircIsInvalid = false
    @State var upperArmCircIsInvalid = false
    @State var lowerArmCircIsInvalid = false
    @State var benchPress1RMIsInvalid = false
    @State var squat1RMIsInvalid = false
    @State var deadLift1RMIsInvalid = false
    @State var shoulderPress1RMIsInvalid = false
    @State var situpsAmrapIsInvalid = false
    @State var pushupsAmrapIsInvalid = false
    
    // Inputfield errormessage states
    @State var chestCircIsInvalidMsg = ""
    @State var waistCircIsInvalidMsg = ""
    @State var thighCircIsInvalidMsg = ""
    @State var calfCircIsInvalidMsg = ""
    @State var upperArmCircIsInvalidMsg = ""
    @State var lowerArmCircIsInvalidMsg = ""
    @State var benchPress1RMIsInvalidMsg = ""
    @State var squat1RMIsInvalidMsg = ""
    @State var deadLift1RMIsInvalidMsg = ""
    @State var shoulderPress1RMIsInvalidMsg = ""
    @State var situpsAmrapIsInvalidMsg = ""
    @State var pushupsAmrapIsInvalidMsg = ""
    
    // Constants specific to elements in this view
    let inputFieldWidth = 0.2
    let minScaleFactor = 0.05
    
    var body: some View {
        
        // Staticly fetch units
        let circumferenceUnit = PersistenceController.getLengthUnit(viewContext)!
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        // Input form for PR's on some common exercises
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
                
                // Inputs for body measurements
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Circumference metrics")
                        .font(.headline)
                    
                    HStack() {
                        Text("Chest circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $chestCirc, markAsWrong: $chestCircIsInvalid, width: inputFieldWidth, errorMessage: $chestCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Waist circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $waistCirc, markAsWrong: $waistCircIsInvalid, width: inputFieldWidth, errorMessage: $waistCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Thigh circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $thighCirc, markAsWrong: $thighCircIsInvalid, width: inputFieldWidth, errorMessage: $thighCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Calf circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $calfCirc, markAsWrong: $calfCircIsInvalid, width: inputFieldWidth, errorMessage: $calfCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Lower arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $lowerArmCirc, markAsWrong: $lowerArmCircIsInvalid, width: inputFieldWidth, errorMessage: $lowerArmCircIsInvalidMsg)
                    }
                    HStack() {
                        Text("Upper arm circumference")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: circumferenceUnit, numberText: $upperArmCirc, markAsWrong: $upperArmCircIsInvalid, width: inputFieldWidth, errorMessage: $upperArmCircIsInvalidMsg)
                    }
                    
                }
                .padding(.top, 40)
                
                // Inputs for PR's
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("One rep max's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Benchpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $benchPress1RM, markAsWrong: $benchPress1RMIsInvalid, width: inputFieldWidth, errorMessage: $benchPress1RMIsInvalidMsg)
                    }
                    HStack() {
                        Text("Squats")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $squat1RM, markAsWrong: $squat1RMIsInvalid, width: inputFieldWidth, errorMessage: $squat1RMIsInvalidMsg)
                    }
                    HStack() {
                        Text("Shoulderpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $shoulderPress1RM, markAsWrong: $shoulderPress1RMIsInvalid, width: inputFieldWidth, errorMessage: $shoulderPress1RMIsInvalidMsg)
                    }
                    HStack() {
                        Text("Deadlift")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $deadLift1RM, markAsWrong: $deadLift1RMIsInvalid, width: inputFieldWidth, errorMessage: $deadLift1RMIsInvalidMsg)
                    }
                }
                .padding(.top, 40)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("AMRAP's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Pushups")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $pushupsAmrap, markAsWrong: $pushupsAmrapIsInvalid, width: inputFieldWidth, errorMessage: $pushupsAmrapIsInvalidMsg)
                    }
                    HStack() {
                        Text("Situps")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: 150)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $situpsAmrap, markAsWrong: $situpsAmrapIsInvalid, width: inputFieldWidth, errorMessage: $situpsAmrapIsInvalidMsg)
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
    
    // Function for validtaing input fields, in the future, remake InputFieldvalidator to an object that has a set min/max etc and make the inputFields tagged so it can decide itself
    private func validateInput() -> Bool {
        var valid: Bool = true
        let doubleFieldValidator = DoubleFieldValidator()
        let intFieldValidator = IntFieldValidator()
        valid = doubleFieldValidator.valideField(inputVar: chestCirc, errorMessage: $chestCircIsInvalidMsg, fieldInvalid: $chestCircIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: waistCirc, errorMessage: $waistCircIsInvalidMsg, fieldInvalid: $waistCircIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: thighCirc, errorMessage: $thighCircIsInvalidMsg, fieldInvalid: $thighCircIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: calfCirc, errorMessage: $calfCircIsInvalidMsg, fieldInvalid: $calfCircIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: upperArmCirc, errorMessage: $upperArmCircIsInvalidMsg, fieldInvalid: $upperArmCircIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: lowerArmCirc, errorMessage: $lowerArmCircIsInvalidMsg, fieldInvalid: $lowerArmCircIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: benchPress1RM, errorMessage: $benchPress1RMIsInvalidMsg, fieldInvalid: $benchPress1RMIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: squat1RM, errorMessage: $squat1RMIsInvalidMsg, fieldInvalid: $squat1RMIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: deadLift1RM, errorMessage: $deadLift1RMIsInvalidMsg, fieldInvalid: $deadLift1RMIsInvalid)
        valid = doubleFieldValidator.valideField(inputVar: shoulderPress1RM, errorMessage: $shoulderPress1RMIsInvalidMsg, fieldInvalid: $shoulderPress1RMIsInvalid)
        valid = intFieldValidator.valideField(inputVar: pushupsAmrap, errorMessage: $pushupsAmrapIsInvalidMsg, fieldInvalid: $pushupsAmrapIsInvalid)
        valid = intFieldValidator.valideField(inputVar: situpsAmrap, errorMessage: $situpsAmrapIsInvalidMsg, fieldInvalid: $situpsAmrapIsInvalid)
        return valid
    }
    
    private func addExtraInfo() {
         
        let firstEntry = bodyEntries.first!
        let bodyWeight = firstEntry.bodyWeight
        firstEntry.chestCirc = Double(chestCirc)!
        firstEntry.waistCirc = Double(waistCirc)!
        firstEntry.thighCirc = Double(thighCirc)!
        firstEntry.calfCirc = Double(calfCirc)!
        firstEntry.uprArmCirc = Double(upperArmCirc)!
        firstEntry.lwrArmCirc = Double(lowerArmCirc)!
        
        PersistenceController.save(viewContext)
        
        // Fetch all the generated exerices so PR's can be added
        @FetchRequest(entity: Exercise.entity(), sortDescriptors: []) var exerciseResults: FetchedResults<Exercise>
        
        // Iterate through basic exercises generated and map the correct values to the correct exercise. Very boilerplaty code, should probably be replaced by something more sophisticated.
        for exercise in exerciseResults {
            
            switch exercise.exerciseName {
            case "Bench-press":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(benchPress1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Squat":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(squat1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Deadlift":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(deadLift1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Shoulder-press":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: Double(shoulderPress1RM)!,
                        q: 1,
                        date: Date(),
                        type: "onerepmax"
                    )
            case "Sit-up":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: bodyWeight,
                        q: Double(situpsAmrap)!,
                        date: Date(),
                        type: "maxreps"
                    )
            case "Push-up":
                _ = PersistenceController.createPersonalRecord(
                        viewContext,
                        exercise: exercise,
                        wl: bodyWeight,
                        q: Double(pushupsAmrap)!,
                        date: Date(),
                        type: "maxreps"
                    )
            default:
                continue
            }
        }
        PersistenceController.save(viewContext)
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    return CreateNewProfile3()
       .environmentObject(ViewRouter())
       .environment(\.managedObjectContext, context)
}
