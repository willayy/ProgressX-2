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
                
                BoldTitle(text: "Editing weigh-in done at")
                    .padding(.horizontal, 20)
                    .onAppear(perform: {
                        viewModel.setViewStartValues(entity: selectedBodyEntry!)
                    })
                
                Title2(text: "\(selectedBodyEntry!.dateString!)")
                
                if viewModel.bodyEntryEditedAlert {
                    SubmitAlert(
                        message: "Successfully edited weigh-in!",
                        color: .green,
                        showAlertState: $viewModel.bodyEntryEditedAlert
                    )
                    .padding(.top, 10)
                } else if viewModel.noChangeAlert {
                    SubmitAlert(
                        message: "No change!",
                        color: .blue,
                        showAlertState: $viewModel.noChangeAlert
                    )
                    .padding(.top, 10)
                }
                
                BoldSubHeadline(text: "Edit date")
                    .padding(.top, 20)
                
                DatePicker("", selection: $viewModel.editedDate, displayedComponents: .date)
                    .datePickerStyle(DefaultDatePickerStyle())
                    .labelsHidden()
                    .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Edit bodyweight")
                
                DecimalTextField(
                    placeHolder: "Bodyweight (\(viewModel.weightUnit(viewContext))",
                    numberText: $viewModel.editedBodyWeight,
                    markAsWrong: $viewModel.editedBodyWeightIsInvalid,
                    errorMessage: $viewModel.editedBodyWeightIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Edit body measurements")
                    .padding(.bottom, 10)
                
                LightSubHeadline(text: "Chest circumference")
                
                DecimalTextField(
                    placeHolder: "Chest circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.editedChestCirc,
                    markAsWrong: $viewModel.editedChestCircIsInvalid,
                    errorMessage: $viewModel.editedChestCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Upper arm circumference")
                
                DecimalTextField(
                    placeHolder: "Upper arm circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.editedUpperArmCirc,
                    markAsWrong: $viewModel.editedUpperArmCircIsInvalid,
                    errorMessage: $viewModel.editedUpperArmCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Lower arm circumference")
                
                DecimalTextField(
                    placeHolder: "Lower arm circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.editedLowerArmCirc,
                    markAsWrong: $viewModel.editedCalfCircIsInvalid,
                    errorMessage: $viewModel.editedLowerArmIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Waist circumference")
                
                DecimalTextField(
                    placeHolder: "Waist circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.editedWaistCirc,
                    markAsWrong: $viewModel.editedWaistCircIsInvalid,
                    errorMessage: $viewModel.editedWaistCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Thigh circumference")
                
                DecimalTextField(
                    placeHolder: "Thigh circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.editedThighCirc,
                    markAsWrong: $viewModel.editedThighCircIsInvalid,
                    errorMessage: $viewModel.editedThighCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 10)
                
                LightSubHeadline(text: "Calf circumference")
                
                DecimalTextField(
                    placeHolder: "Calf circumference (\(viewModel.lengthUnit(viewContext)))",
                    numberText: $viewModel.editedCalfCirc,
                    markAsWrong: $viewModel.editedCalfCircIsInvalid,
                    errorMessage: $viewModel.editedCalfCircIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                Button {
                    if validateInput() {
                        viewModel.saveEdits(
                            entity: selectedBodyEntry!,
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
    let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    @State var selectedBodyEntry: BodyEntry? = results.first!
    
    return EditWeighInView(
        selectedBodyEntry: $selectedBodyEntry
    )
    .environment(\.managedObjectContext, context)
}
