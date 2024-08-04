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
                
                BoldTitle(text: "Editing PR for")
                    .padding(.horizontal, 20)
                    .onAppear(perform: {
                        viewModel.setViewStartValues(entity: editingPr!)
                    })
                
                Title2(text: "\(exercise!.exerciseName!)")
                
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
                
                GroupBox {
                    VStack(alignment: .leading) {
                        
                        (Text("Type: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text(editingPr!.typeString!)
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
                         + Text("\(editingPr!.loadString!)")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                        (Text("Quantity: ")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                         + Text("\(editingPr!.quantityString!)")
                            .fontWeight(.light)
                            .foregroundColor(.black))
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.5)
                        
                    }
                }
                .padding(.top, 10)
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Edit date")
                
                DatePicker("", selection: $viewModel.editedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Edit load")
                    .padding(.top, 10)
                
                DecimalTextField(
                    placeHolder: "Load",
                    numberText: $viewModel.editedWeightLoad,
                    markAsWrong: $viewModel.editedWeightLoadInvalid,
                    errorMessage: $viewModel.editedWeightLoadInvalidMsg,
                    bodyWeightButton: true
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                if editingPr!.prType == "maxreps" {
                    
                    BoldSubHeadline(text: "Edit reps")
                    
                    IntegerTextField(
                        placeHolder: "Reps",
                        numberText: $viewModel.editedQuantity,
                        markAsWrong: $viewModel.editedQuantityInvalid,
                        errorMessage: $viewModel.editedQuantityInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                } else if editingPr!.prType == "timemax" {
                    
                    BoldSubHeadline(text: "Edit time")
                    
                    DecimalTextField(
                        placeHolder: "Time", 
                        numberText: $viewModel.editedQuantity,
                        markAsWrong: $viewModel.editedQuantityInvalid,
                        errorMessage: $viewModel.editedQuantityInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    .padding(.bottom, 10)
                }
                
                Button(action: {
                    if validateInput() {
                        viewModel.saveEdits(entity: editingPr!, viewContext: viewContext)
                    }
                }) {
                    Text("Save changes")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                if viewModel.savingError {
                    SavingErrorText()
                        .padding(.horizontal, 20)
                }
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        let loadFieldValidator = DoubleFieldValidator(maxInputNumber: 10000)
        let quantityFieldValidator: InputFieldValidator = {
            return (editingPr!.prType == "timemax" ? DoubleFieldValidator(maxInputNumber: 100000) : IntFieldValidator(minInputNumber: 100000))
        }()
        
        valid += loadFieldValidator.valideField(
            inputVar: viewModel.editedWeightLoad,
            errorMessage: $viewModel.editedWeightLoadInvalidMsg,
            fieldInvalid: $viewModel.editedWeightLoadInvalid
        )
        
        valid += quantityFieldValidator.valideField(
            inputVar: viewModel.editedQuantity,
            errorMessage: $viewModel.editedQuantityInvalidMsg,
            fieldInvalid: $viewModel.editedQuantityInvalid
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
