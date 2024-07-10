//
//  EditPrView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-06-03.
//

import SwiftUI
import CoreData

struct EditPrView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var editingPr: PersonalRecord?
    @Binding var exercise: Exercise?
    @StateObject private var viewModel = EditPrViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                
                BoldTitle(text: "Editing PR for: \(exercise!.exerciseName!)")
                
                if viewModel.prEditedAlert {
                    SubmitAlert(
                        message: "Succesfully edited PR!",
                        color: .green,
                        showAlertState: $viewModel.prEditedAlert
                    )
                }
                
                if viewModel.noChangeAlert {
                    SubmitAlert(
                        message: "No changes to PR",
                        color: .blue,
                        showAlertState: $viewModel.noChangeAlert
                    )
                }
                
                VStack(alignment: .leading) {
                    
                    (Text("Type: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text(editingPr!.typeString)
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Achieved on date: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.dateString!)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Load: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.loadString)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                    
                    (Text("Quantity: ")
                        .font(.subheadline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                     + Text("\(editingPr!.quantityString)")
                        .fontWeight(.light)
                        .foregroundColor(.black))
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(0.5)
                
                }
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change date")
                
                DatePicker("", selection: $viewModel.newDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                
                InputDecimalNumberField(
                    placeHolder: "New load",
                    allowNegatives: false,
                    numberText: $viewModel.newWeightLoad,
                    markAsWrong: $viewModel.newWeightLoadInvalid,
                    width: 0.7,
                    errorMessage: $viewModel.newWeightLoadInvalidMsg
                )
                .padding(.top, 10)
                .padding(.bottom, 10)
                
                if editingPr!.prType == "maxreps" {
                    InputIntegerNumberField(
                        placeHolder: "New reps",
                        allowNegatives: false,
                        numberText: $viewModel.newQuantity,
                        markAsWrong: $viewModel.newQuantityInvalid,
                        width: 0.7,
                        errorMessage: $viewModel.newQuantityInvalidMsg
                    )
                    .padding(.bottom, 10)
                } else if editingPr!.prType == "timemax" {
                    InputDecimalNumberField(
                        placeHolder: "New time...", 
                        allowNegatives: false,
                        numberText: $viewModel.newQuantity,
                        markAsWrong: $viewModel.newQuantityInvalid,
                        width: 0.7,
                        errorMessage: $viewModel.newQuantityInvalidMsg
                    )
                    .padding(.bottom, 10)
                }
                
                Button(action: {
                    if validateInput() {
                        viewModel.savePersonalRecordChanges(
                            viewContext: viewContext,
                            editingPr: editingPr
                        )
                    }
                }) {
                    Text("Save changes")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
                
            }
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(editingPr: editingPr)
        })
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let loadFieldValidator = DoubleFieldValidator()
        let quantityFieldValidator: InputFieldValidator = {
            return (editingPr!.prType == "timemax" ? DoubleFieldValidator() : IntFieldValidator())
        }()
        
        valid += loadFieldValidator.valideField(
            inputVar: viewModel.newWeightLoad,
            errorMessage: $viewModel.newWeightLoadInvalidMsg,
            fieldInvalid: $viewModel.newWeightLoadInvalid
        )
        
        valid += quantityFieldValidator.valideField(
            inputVar: viewModel.newQuantity,
            errorMessage: $viewModel.newQuantityInvalidMsg,
            fieldInvalid: $viewModel.newQuantityInvalid
        )
        
        return valid == 0
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    let fetchRequest: NSFetchRequest<Exercise> = Exercise.fetchRequest()
    
    let exerciseResults: [Exercise] = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    
    @State var exercise: Exercise? = exerciseResults.first
    
    @State var pr: PersonalRecord? = exercise?.personalRecords?.allObjects.first as? PersonalRecord
    
    return EditPrView(editingPr: $pr, exercise: $exercise)
    .environment(\.managedObjectContext, context)
}
