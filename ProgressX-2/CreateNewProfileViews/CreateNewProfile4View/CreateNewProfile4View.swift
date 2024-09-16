//
//  CreateNewProfile4.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-14.
//

import SwiftUI

struct CreateNewProfile4View: View {
    
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
    
    @EnvironmentObject var viewRouter: ViewRouter
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @Binding var navPath: [Int]
    
    @StateObject private var viewModel = CreateNewProfile4ViewModel()
    
    var body: some View {
            
        ScrollView(showsIndicators: false) {
            
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information on basic exercises")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                Text("Please fill in all the following fields of personal records for some basic exercises, these are only your initial PR's for these exercises. You can add more PR's later!")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                // Inputs for PR's
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("One rep max's")
                        .font(.headline)
                    
                    HiddenLightSubHeadline(title: "I dont know what to write here?", text: "If you dont know what your one rep max (the maximum amount of weight you can lift for a single repetition of a specific exercise) is on some of these exercises just try to approximate it, preferably on the lower side.")
                    
                    HStack {
                        
                        Text("Bench press")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.benchPress1RM,
                            markAsWrong: $viewModel.benchPress1RMIsInvalid,
                            errorMessage: $viewModel.benchPress1RMIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Shoulder press")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.shoulderPress1RM,
                            markAsWrong: $viewModel.shoulderPress1RMIsInvalid,
                            errorMessage: $viewModel.shoulderPress1RMIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Squats")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.squat1RM,
                            markAsWrong: $viewModel.squat1RMIsInvalid,
                            errorMessage: $viewModel.squat1RMIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Deadlift")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.deadLift1RM,
                            markAsWrong: $viewModel.deadLift1RMIsInvalid,
                            errorMessage: $viewModel.deadLift1RMIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Barbell row")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.barbellRow1RM,
                            markAsWrong: $viewModel.barbellRow1RMIsInvalid,
                            errorMessage: $viewModel.barbellRow1RMIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Overhead tricep extension")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.overheadTriExt1RM,
                            markAsWrong: $viewModel.overheadTriExt1RMIsInvalid,
                            errorMessage: $viewModel.overheadTriExt1RMIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Dumbbell curl")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        DecimalTextField(
                            placeHolder: viewModel.weightUnit(viewContext),
                            numberText: $viewModel.dumbbellCurl1RM,
                            markAsWrong: $viewModel.dumbbellCurl1RMIsInvalid,
                            errorMessage: $viewModel.dumbbellCurl1RMIsInvalidMsg
                        )
                        
                    }
                    
                }
                .padding(.horizontal, 55)
                .padding(.top, 20)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("AMRAP's")
                        .font(.headline)
                    
                    HiddenLightSubHeadline(title: "What is AMRAP?", text: "AMRAP means as many reps as possible. We want to know how many reps you can achieve doing these following exercises with only your bodyweight.")
                    
                    HStack {
                        
                        Text("Push-up")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        IntegerTextField(
                            placeHolder: "reps",
                            numberText: $viewModel.pushupsAmrap,
                            markAsWrong: $viewModel.pushupsAmrapIsInvalid,
                            errorMessage: $viewModel.pushupsAmrapIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Sit-up")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        IntegerTextField(
                            placeHolder: "reps",
                            numberText: $viewModel.situpsAmrap,
                            markAsWrong: $viewModel.situpsAmrapIsInvalid,
                            errorMessage: $viewModel.situpsAmrapIsInvalidMsg
                        )
                        
                    }
                    
                    HStack {
                        
                        Text("Chin-up")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(
                                width: viewModel.textWidth,
                                alignment: .leading
                            )
                        
                        Spacer(minLength: 50)
                        
                        IntegerTextField(
                            placeHolder: "reps",
                            numberText: $viewModel.chinupsAmrap,
                            markAsWrong: $viewModel.chinupsAmrapIsInvalid,
                            errorMessage: $viewModel.chinupsAmrapIsInvalidMsg
                        )
                        
                    }
                    
                }
                .padding(.horizontal, 55)
                .padding(.top, 20)
                
            }
        }
                
        Button {
            if validateInput() {
                
                viewModel.bodyWeight = bodyEntries.first?.bodyWeight
                viewModel.saveEntry(viewContext: viewContext)
                viewModel.generateBasicRoutine(viewContext: viewContext)
                
                withAnimation {
                    viewRouter.startView = .None
                    viewRouter.rootView = .HomeView
                }
            }
        } label: {
            Text("Finish")
                .frame(width: 100, height: 40)
                .foregroundColor(Color("buttonTextColor"))
        }
        .buttonStyle(.borderedProminent)
        .padding(.vertical, 20)
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator(maxInputNumber: 10000)
        let intFieldValidator = IntFieldValidator(maxInputNumber: 100000)
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.benchPress1RM,
            errorMessage: $viewModel.benchPress1RMIsInvalidMsg,
            fieldInvalid: $viewModel.benchPress1RMIsInvalid
        )
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.squat1RM,
            errorMessage: $viewModel.squat1RMIsInvalidMsg,
            fieldInvalid: $viewModel.squat1RMIsInvalid
        )
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.deadLift1RM,
            errorMessage: $viewModel.deadLift1RMIsInvalidMsg,
            fieldInvalid: $viewModel.deadLift1RMIsInvalid
        )
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.barbellRow1RM,
            errorMessage: $viewModel.barbellRow1RMIsInvalidMsg,
            fieldInvalid: $viewModel.barbellRow1RMIsInvalid
        )
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.dumbbellCurl1RM,
            errorMessage: $viewModel.dumbbellCurl1RMIsInvalidMsg,
            fieldInvalid: $viewModel.dumbbellCurl1RMIsInvalid
        )
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.shoulderPress1RM,
            errorMessage: $viewModel.shoulderPress1RMIsInvalidMsg,
            fieldInvalid: $viewModel.shoulderPress1RMIsInvalid
        )
        
        valid += doubleFieldValidator.validateField(
            inputVar: viewModel.overheadTriExt1RM,
            errorMessage: $viewModel.overheadTriExt1RMIsInvalidMsg,
            fieldInvalid: $viewModel.overheadTriExt1RMIsInvalid
        )
        
        // Validation for the AMRAP entries
        
        valid += intFieldValidator.validateField(
            inputVar: viewModel.pushupsAmrap,
            errorMessage: $viewModel.pushupsAmrapIsInvalidMsg,
            fieldInvalid: $viewModel.pushupsAmrapIsInvalid
        )
        
        valid += intFieldValidator.validateField(
            inputVar: viewModel.situpsAmrap,
            errorMessage: $viewModel.situpsAmrapIsInvalidMsg,
            fieldInvalid: $viewModel.situpsAmrapIsInvalid
        )
        
        valid += intFieldValidator.validateField(
            inputVar: viewModel.chinupsAmrap,
            errorMessage: $viewModel.chinupsAmrapIsInvalidMsg,
            fieldInvalid: $viewModel.chinupsAmrapIsInvalid
        )
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.previewViewContext
    
    @State var navPath = [Int]()
    
    return CreateNewProfile4View(navPath: $navPath)
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
