//
//  CreateNewPersonalRecord.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-17.
//

import SwiftUI
import CoreData

struct CreateNewPersonalRecord: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    // Fetch bodyEntres to get current weight
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: false)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    // Date picker value
    @State var prDate: Date = Date()
    
    // The selection of the segmentex picker
    @Binding var prType: String?
    
    // Exercise for the PR
    @Binding var exercise: Exercise?
    
    // Input field vars
    @State var prQuantity: String = ""
    @State var prLoad: String = ""
    @State var prLoadIsInvalid: Bool = false
    @State var prQuantityIsInvalid: Bool = false
    @State var prLoadIsInvalidMsg: String = ""
    @State var prQuantityIsInvalidMsg: String = ""
    
    // Show alert vars
    @State var createdPrAlert: Bool = false
    
    // Segment picker options
    private let repBasedPrOptions: [String] = ["AMRAP", "1RM"]
    
    var body: some View {
        
        ScrollView {
            VStack {
                BoldTitle(text: "Create a new PR for exercise: \(exercise!.exerciseName!)")
                    .padding(.bottom, 20)
                
                if createdPrAlert {
                    SubmitAlert(message: "Succesfully created new PR!", color: .green, showAlertState: $createdPrAlert)
                }
                
                LightSubHeadline(text: "Choose a date for the PR")
                
                DatePicker("", selection: $prDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 20)
                
                InputDecimalNumberField(
                    placeHolder: "Load",
                    numberText: $prLoad,
                    markAsWrong: $prLoadIsInvalid,
                    width: 0.6,
                    errorMessage: $prLoadIsInvalidMsg
                )
                .padding(.bottom, 10)
                .onAppear(perform: {
                    if prType == "onerepmax" {
                        prQuantity = "1"
                    }
                })
                    
                if prType == "maxreps" {
                    InputIntegerNumberField(
                        placeHolder: "Reps",
                        numberText: $prQuantity,
                        markAsWrong: $prQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $prQuantityIsInvalidMsg
                    )
                }
                
                else if prType == "timemax" {
                    InputDecimalNumberField(
                        placeHolder: "Seconds",
                        numberText: $prQuantity,
                        markAsWrong: $prQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $prQuantityIsInvalidMsg
                    )
                }
                
                // MARK: Handle the creation of a PR
                Button(action: {
                    if validateInput() {
                        
                        // Create the PR
                        let pr: PersonalRecord = PersistenceController.createPersonalRecord(
                            viewContext,
                            exercise: exercise!,
                            wl: Double(prLoad)!,
                            q: Double(prQuantity)!,
                            date: prDate,
                            type: prType!
                        )
                        
                        exercise!.addToPersonalRecords(pr)
                        
                        PersistenceController.save(viewContext)
                        
                        // Reset the view state with an animation
                        withAnimation {
                            prDate = Date()
                            prLoad = ""
                            prQuantity = ""
                            createdPrAlert = true
                        }
                        
                    }
                }) {
                    Text("Save changes")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .padding(.top, 20)
                .buttonStyle(BorderedProminentButtonStyle())
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        var quantityValidator: InputFieldValidator
        let loadValidator: InputFieldValidator = DoubleFieldValidator()
        
        if prType == "timemax" {
            quantityValidator = DoubleFieldValidator()
        } else {
            quantityValidator = IntFieldValidator()
        }
        
        valid += loadValidator.valideField(
            inputVar: prLoad,
            errorMessage: $prLoadIsInvalidMsg,
            fieldInvalid: $prLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: prQuantity,
            errorMessage: $prQuantityIsInvalidMsg,
            fieldInvalid: $prQuantityIsInvalid
        )
        
        
        return valid == 0
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequestRepBasedExercise: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    fetchRequestRepBasedExercise.predicate = NSPredicate(format: "exerciseType == %@", "reps")
    
    let exerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequestRepBasedExercise)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var prType: String? = "onerepmax"
    
    return CreateNewPersonalRecord(prType: $prType, exercise: $exercise)
}
