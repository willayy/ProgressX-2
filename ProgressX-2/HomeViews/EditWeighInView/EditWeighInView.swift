//
//  EditWeighInView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-18.
//

import SwiftUI
import CoreData

struct EditWeighInView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var selectedBodyEntry: BodyEntry?
    @StateObject private var viewModel = EditWeighInViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                
                BoldTitle(text: "Editing weigh-in done at: \(selectedBodyEntry!.dateString!)")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                if viewModel.bodyEntryEditedAlert {
                    SubmitAlert(
                        message: "Successfully edited weigh-in!",
                        color: .green,
                        showAlertState: $viewModel.bodyEntryEditedAlert
                    )
                } else if viewModel.noChangeAlert {
                    SubmitAlert(
                        message: "No change!",
                        color: .blue,
                        showAlertState: $viewModel.noChangeAlert
                    )
                }
                
                BoldSubHeadline(text: "Change date")
                
                DatePicker("", selection: $viewModel.editedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Change bodyweight")
                
                let weightUnit = PersistenceController.getWeightUnit(viewContext)!
                
                let lengthUnit = PersistenceController.getLengthUnit(viewContext)!
                
                InputDecimalNumberField(
                    placeHolder: "Bodyweight (\(weightUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedBodyWeight,
                    markAsWrong: $viewModel.editedBodyWeightIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedBodyWeightIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Change body measurements")
                    .padding(.bottom, 10)
                
                LightSubHeadline(text: "Chest circumference")
                
                InputDecimalNumberField(
                    placeHolder: "Chest circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedChestCirc,
                    markAsWrong: $viewModel.editedChestCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedChestCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Upper arm circumference")
                
                InputDecimalNumberField(
                    placeHolder: "Upper arm circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedUpperArmCirc,
                    markAsWrong: $viewModel.editedUpperArmCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedUpperArmCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Lower arm circumference")
                
                InputDecimalNumberField(
                    placeHolder: "Lower arm circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedLowerArmCirc,
                    markAsWrong: $viewModel.editedCalfCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedLowerArmIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Waist circumference")
                
                InputDecimalNumberField(
                    placeHolder: "Waist circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedWaistCirc,
                    markAsWrong: $viewModel.editedWaistCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedWaistCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Thigh circumference")
                
                InputDecimalNumberField(
                    placeHolder: "Thigh circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedThighCirc,
                    markAsWrong: $viewModel.editedThighCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedThighCircIsInvalidMsg
                )
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Calf circumference")
                
                InputDecimalNumberField(
                    placeHolder: "Calf circumference (\(lengthUnit))",
                    allowNegatives: false,
                    numberText: $viewModel.editedCalfCirc,
                    markAsWrong: $viewModel.editedCalfCircIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedCalfCircIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                Button {
                    if validateInput() {
                        viewModel.saveBodyEntryChanges(
                            bodyEntry: selectedBodyEntry!,
                            viewContext: viewContext
                        )
                    }
                } label: {
                    Text("Save changes")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "square.and.arrow.down")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                .padding(.bottom, 10)
                
            }
            .frame(maxWidth: .infinity)
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(bodyEntry: selectedBodyEntry!)
        })
    }
    
    private func validateInput() -> Bool {
        var valid: Int = 0
        
        let bodyWeightValidator = DoubleFieldValidator(maxInputNumber: 1000)
        let bodyMeasurementValidator = DoubleFieldValidator(emptyAllowed: true, maxInputNumber: 1000)
        
        valid += bodyWeightValidator.valideField(
            inputVar: viewModel.editedBodyWeight,
            errorMessage: $viewModel.editedBodyWeightIsInvalidMsg,
            fieldInvalid: $viewModel.editedBodyWeightIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.editedChestCirc,
            errorMessage: $viewModel.editedChestCircIsInvalidMsg,
            fieldInvalid: $viewModel.editedChestCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.editedUpperArmCirc,
            errorMessage: $viewModel.editedUpperArmCircIsInvalidMsg,
            fieldInvalid: $viewModel.editedUpperArmCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.editedLowerArmCirc,
            errorMessage: $viewModel.editedLowerArmIsInvalidMsg,
            fieldInvalid: $viewModel.editedLowerArmIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.editedWaistCirc,
            errorMessage: $viewModel.editedWaistCircIsInvalidMsg,
            fieldInvalid: $viewModel.editedWaistCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.editedThighCirc,
            errorMessage: $viewModel.editedThighCircIsInvalidMsg,
            fieldInvalid: $viewModel.editedThighCircIsInvalid
        )
        
        valid += bodyMeasurementValidator.valideField(
            inputVar: viewModel.editedCalfCirc,
            errorMessage: $viewModel.editedCalfCircIsInvalidMsg,
            fieldInvalid: $viewModel.editedCalfCircIsInvalid
        )
        
        return valid == 0
        
    }
    
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest<BodyEntry> = BodyEntry.fetchRequest()
    let results = PersistenceController.fetch(context, fetchRequest: fetchRequest)
    @State var selectedBodyEntry: BodyEntry? = results.first!
    
    return EditWeighInView(
        selectedBodyEntry: $selectedBodyEntry
    )
    .environment(\.managedObjectContext, context)
}
