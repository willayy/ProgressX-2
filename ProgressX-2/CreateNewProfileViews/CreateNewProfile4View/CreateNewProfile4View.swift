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
        
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 10) {
                Text("Extra information on basic exercises")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                Text("Please fill in all the following fields of personal records for some basic exercises, this is only your initial PR's for these exercises. You can add more PR's in the future!")
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
                    
                    HStack() {
                        Text("Benchpress")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        DecimalTextField(
                            placeHolder: weightUnit, 
                            numberText: $viewModel.benchPress1RM,
                            markAsWrong: $viewModel.benchPress1RMIsInvalid,
                            errorMessage: $viewModel.benchPress1RMIsInvalidMsg
                        )
                        .padding(.horizontal, 30)
                    }
                    HStack() {
                        Text("Squats")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        DecimalTextField(
                            placeHolder: weightUnit, 
                            numberText: $viewModel.squat1RM,
                            markAsWrong: $viewModel.squat1RMIsInvalid,
                            errorMessage: $viewModel.squat1RMIsInvalidMsg
                        )
                        .padding(.horizontal, 30)
                    }
                    HStack() {
                        Text("Shoulderpress")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        DecimalTextField(
                            placeHolder: weightUnit, 
                            numberText: $viewModel.shoulderPress1RM,
                            markAsWrong: $viewModel.shoulderPress1RMIsInvalid,
                            errorMessage: $viewModel.shoulderPress1RMIsInvalidMsg
                        )
                        .padding(.horizontal, 30)
                    }
                    HStack() {
                        Text("Deadlift")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        DecimalTextField(
                            placeHolder: weightUnit, 
                            numberText: $viewModel.deadLift1RM,
                            markAsWrong: $viewModel.deadLift1RMIsInvalid,
                            errorMessage: $viewModel.deadLift1RMIsInvalidMsg
                        )
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("AMRAP's")
                        .font(.headline)
                    
                    HStack() {
                        Text("Pushups")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        IntegerTextField(
                            placeHolder: "reps", 
                            numberText: $viewModel.pushupsAmrap,
                            markAsWrong: $viewModel.pushupsAmrapIsInvalid,
                            errorMessage: $viewModel.pushupsAmrapIsInvalidMsg
                        )
                        .padding(.horizontal, 30)
                    }
                    HStack() {
                        Text("Situps")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        IntegerTextField(
                            placeHolder: "reps", 
                            numberText: $viewModel.situpsAmrap,
                            markAsWrong: $viewModel.situpsAmrapIsInvalid,
                            errorMessage: $viewModel.situpsAmrapIsInvalidMsg
                        )
                        .padding(.horizontal, 30)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                
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
                        .frame(width: 100, height: 30)
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(.borderedProminent)
                .padding(.vertical, 20)
                
                if viewModel.savingError {
                    SavingErrorText()
                        .padding(.horizontal, 20)
                }
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator(maxInputNumber: 10000)
        let intFieldValidator = IntFieldValidator(maxInputNumber: 100000)
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.benchPress1RM,
            errorMessage: $viewModel.benchPress1RMIsInvalidMsg,
            fieldInvalid: $viewModel.benchPress1RMIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.squat1RM,
            errorMessage: $viewModel.squat1RMIsInvalidMsg,
            fieldInvalid: $viewModel.squat1RMIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.deadLift1RM,
            errorMessage: $viewModel.deadLift1RMIsInvalidMsg,
            fieldInvalid: $viewModel.deadLift1RMIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.shoulderPress1RM,
            errorMessage: $viewModel.shoulderPress1RMIsInvalidMsg,
            fieldInvalid: $viewModel.shoulderPress1RMIsInvalid
        )
        
        valid += intFieldValidator.valideField(
            inputVar: viewModel.pushupsAmrap,
            errorMessage: $viewModel.pushupsAmrapIsInvalidMsg,
            fieldInvalid: $viewModel.pushupsAmrapIsInvalid
        )
        
        valid += intFieldValidator.valideField(
            inputVar: viewModel.situpsAmrap,
            errorMessage: $viewModel.situpsAmrapIsInvalidMsg,
            fieldInvalid: $viewModel.situpsAmrapIsInvalid
        )
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    @State var navPath = [Int]()
    
    return CreateNewProfile4View(navPath: $navPath)
        .environmentObject(ViewRouter())
        .environment(\.managedObjectContext, context)
}
