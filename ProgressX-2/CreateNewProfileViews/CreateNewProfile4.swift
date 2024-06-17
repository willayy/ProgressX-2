//
//  CreateNewProfile4.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import SwiftUI

struct CreateNewProfile4: View {
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    // Fetch all the generated exerices so PR's can be added
    @FetchRequest(
        entity: Exercise.entity(),
        sortDescriptors: []
    ) private var exercises: FetchedResults<Exercise>
    
    // Fetch all BodyEntries so the latest entry can be used as load for the AMRAP Pr's
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    // Fetch all PersonalRecords to ensure this View doesnt produce more than one set of PersonalRecords for the starting exercises. At this state in the app the only PersonalRecords are the ones created in this View.
    @FetchRequest(
        entity: PersonalRecord.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \PersonalRecord.achievedOnDate, ascending: true)]
    ) private var personalRecords: FetchedResults<PersonalRecord>
    
    // Values for input fields
    @State var benchPress1RM = ""
    @State var squat1RM = ""
    @State var deadLift1RM = ""
    @State var shoulderPress1RM = ""
    @State var pushupsAmrap = ""
    @State var situpsAmrap = ""

    // Valid states for inputfields
    @State var benchPress1RMIsInvalid = false
    @State var squat1RMIsInvalid = false
    @State var deadLift1RMIsInvalid = false
    @State var shoulderPress1RMIsInvalid = false
    @State var situpsAmrapIsInvalid = false
    @State var pushupsAmrapIsInvalid = false

    // Error messages for inputfields
    @State var benchPress1RMIsInvalidMsg = ""
    @State var squat1RMIsInvalidMsg = ""
    @State var deadLift1RMIsInvalidMsg = ""
    @State var shoulderPress1RMIsInvalidMsg = ""
    @State var situpsAmrapIsInvalidMsg = ""
    @State var pushupsAmrapIsInvalidMsg = ""
    
    // Constants specific to elements in this view
    let inputFieldWidth: Double = 0.2
    let minScaleFactor: Double = 0.05
    let textWidth: Double = 150
    
    var body: some View {
        
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 10) {
                Text("Extra information on basic exercises")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(minScaleFactor);
                
                Text("Please fill in all the following fields of personal records for some basic exercises, this is only your initial PR's for these exercises. You can add more PR's in the future!")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(minScaleFactor);
                
                // Inputs for PR's
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("One rep max's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Benchpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $benchPress1RM, markAsWrong: $benchPress1RMIsInvalid, width: inputFieldWidth, errorMessage: $benchPress1RMIsInvalidMsg)
                    }
                    HStack() {
                        Text("Squats")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $squat1RM, markAsWrong: $squat1RMIsInvalid, width: inputFieldWidth, errorMessage: $squat1RMIsInvalidMsg)
                    }
                    HStack() {
                        Text("Shoulderpress")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
                        InputDecimalNumberField(placeHolder: weightUnit, numberText: $shoulderPress1RM, markAsWrong: $shoulderPress1RMIsInvalid, width: inputFieldWidth, errorMessage: $shoulderPress1RMIsInvalidMsg)
                    }
                    HStack() {
                        Text("Deadlift")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
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
                            .frame(width: textWidth)
                        InputIntegerNumberField(placeHolder: "reps", numberText: $pushupsAmrap, markAsWrong: $pushupsAmrapIsInvalid, width: inputFieldWidth, errorMessage: $pushupsAmrapIsInvalidMsg)
                    }
                    HStack() {
                        Text("Situps")
                            .minimumScaleFactor(minScaleFactor)
                            .frame(width: textWidth)
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
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator()
        let intFieldValidator = IntFieldValidator()
        valid += doubleFieldValidator.valideField(inputVar: benchPress1RM, errorMessage: $benchPress1RMIsInvalidMsg, fieldInvalid: $benchPress1RMIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: squat1RM, errorMessage: $squat1RMIsInvalidMsg, fieldInvalid: $squat1RMIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: deadLift1RM, errorMessage: $deadLift1RMIsInvalidMsg, fieldInvalid: $deadLift1RMIsInvalid)
        valid += doubleFieldValidator.valideField(inputVar: shoulderPress1RM, errorMessage: $shoulderPress1RMIsInvalidMsg, fieldInvalid: $shoulderPress1RMIsInvalid)
        valid += intFieldValidator.valideField(inputVar: pushupsAmrap, errorMessage: $pushupsAmrapIsInvalidMsg, fieldInvalid: $pushupsAmrapIsInvalid)
        valid += intFieldValidator.valideField(inputVar: situpsAmrap, errorMessage: $situpsAmrapIsInvalidMsg, fieldInvalid: $situpsAmrapIsInvalid)
        return valid == 0
    }
    
    private func addExtraInfo() {
        
        let bodyWeight: Double = bodyEntries.first!.bodyWeight
        
        // Wipe all prs
        for pr in personalRecords {
            PersistenceController.delete(viewContext, object: pr)
        }
        
        PersistenceController.save(viewContext)
        
        // Iterate through basic exercises generated and map the correct values to the correct exercise. Very boilerplaty code, should probably be replaced by something more sophisticated.
        for exercise in exercises {
            
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
    
    @State var navPath = [Int]()
    
    return CreateNewProfile4(navPath: $navPath)
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
