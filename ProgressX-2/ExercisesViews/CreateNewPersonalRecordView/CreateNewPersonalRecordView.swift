//
//  CreateNewPersonalRecord.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import SwiftUI
import CoreData

struct CreateNewPersonalRecord: View {
    
    // Fetch bodyEntres to get current weight
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: false)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    @Binding var prType: String? // The selection of the segmented picker
    @Binding var navPath: [Int]
    @Binding var selectedExercise: Exercise? // Exercise for the PR
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var viewModel = CreateNewPersonalRecordViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                BoldTitle(
                    text: "Create a new PR for"
                )
                .padding(.horizontal, 20)
                
                Title2(text: "\(selectedExercise!.exerciseName!)")
                .padding(.horizontal, 20)
                
                HiddenLightSubHeadline(
                    title: "What are PR's?",
                    text: "A PR (personal record) is a dated record of how you performed on an exercise. For rep based exercises the available PR's are AMRAP (As many reps as possible) and 1RM (one rep max). For time based exercise there is only Time-max PR's which is like an AMRAP PR but instead of counting the reps you did it counts the time you did."
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Choose a date for the PR")
                
                DatePicker("", selection: $viewModel.prDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Choose a load for the PR")
                
                DecimalTextField(
                    placeHolder: "Load", 
                    numberText: $viewModel.prLoad,
                    markAsWrong: $viewModel.prLoadIsInvalid,
                    errorMessage: $viewModel.prLoadIsInvalidMsg,
                    bodyWeightButton: true
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                .onAppear(perform: {
                    if prType == "onerepmax" {
                        viewModel.prQuantity = "1"
                    }
                })
                    
                if prType == "maxreps" {
                    IntegerTextField(
                        placeHolder: "Reps", 
                        numberText: $viewModel.prQuantity,
                        markAsWrong: $viewModel.prQuantityIsInvalid,
                        errorMessage: $viewModel.prQuantityIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                }
                
                else if prType == "timemax" {
                    DecimalTextField(
                        placeHolder: "Seconds", 
                        numberText: $viewModel.prQuantity,
                        markAsWrong: $viewModel.prQuantityIsInvalid,
                        errorMessage: $viewModel.prQuantityIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                }
                
                // MARK: Handle the creation of a PR
                Button(action: {
                    if validateInput() {
                        viewModel.selectedExercise = selectedExercise!
                        viewModel.selectedPrType = prType!
                        viewModel.saveEntry(viewContext: viewContext)
                        navPath.removeLast()
                    }
                }) {
                    Text("Create new PR")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "plus")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .padding(.top, 20)
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.bottom, 10)
                
            }
            .frame(maxWidth: .infinity)
        }
    }
    
    private func validateInput() -> Bool {
        
        var valid: Int = 0
        
        var quantityValidator: InputFieldValidator
        
        let loadValidator: InputFieldValidator = DoubleFieldValidator(maxInputNumber: 10000)
        
        if prType == "timemax" {
            quantityValidator = DoubleFieldValidator(maxInputNumber: 100000)
        } else {
            quantityValidator = IntFieldValidator(maxInputNumber: 100000)
        }
        
        valid += loadValidator.valideField(
            inputVar: viewModel.prLoad,
            errorMessage: $viewModel.prLoadIsInvalidMsg,
            fieldInvalid: $viewModel.prLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: viewModel.prQuantity,
            errorMessage: $viewModel.prQuantityIsInvalidMsg,
            fieldInvalid: $viewModel.prQuantityIsInvalid
        )
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestRepBasedExercise.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResults: [Exercise] = CoreDataAccess.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var prType: String? = "onerepmax"
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewPersonalRecord(
        prType: $prType,
        navPath: $navPath,
        selectedExercise: $exercise
    )
}
