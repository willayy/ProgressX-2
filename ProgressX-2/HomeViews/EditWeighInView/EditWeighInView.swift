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
            
            BoldTitle(text: "Editing weigh-in done at")
                .padding(.horizontal, 20)
                .onAppear(perform: {
                    viewModel.setViewStartValues(entity: selectedBodyEntry!)
                })
            
            Title2(text: "\(selectedBodyEntry!.dateString!)")
            
            // MARK: Submission alert states
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
            
            // MARK: Date
            BoldSubHeadline(text: "Edit date")
                .padding(.top, 20)
            
            DatePicker("", selection: $viewModel.editedDate, displayedComponents: .date)
                .datePickerStyle(DefaultDatePickerStyle())
                .labelsHidden()
                .padding(.bottom, 10)
            
            // MARK: Bodyweight
            BoldSubHeadline(text: "Edit bodyweight")
            
            let weightUnit = viewModel.weightUnit(viewContext)
            
            InputField(
                placeHolder: "Bodyweight (\(weightUnit))",
                text: $viewModel.editedBodyWeight,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Body measurements
            BoldSubHeadline(text: "Edit body measurements")
                .padding(.bottom, 10)
            
            // MARK: Chest circumference
            LightSubHeadline(text: "Chest circumference")
            
            let lengthUnit = viewModel.lengthUnit(viewContext)
            
            InputField(
                placeHolder: "Chestcircumference (\(lengthUnit))",
                text: $viewModel.editedChestCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Upper arm circumference
            LightSubHeadline(text: "Upper arm circumference")
            
            InputField(
                placeHolder: "Upper arm circumference (\(lengthUnit))",
                text: $viewModel.editedUpperArmCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Lower arm circumference
            LightSubHeadline(text: "Lower arm circumference")
            
            InputField(
                placeHolder: "Lower arm circumference (\(lengthUnit))",
                text: $viewModel.editedLowerArmCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Waist circumference
            LightSubHeadline(text: "Waist circumference")
            
            InputField(
                placeHolder: "Waist circumference (\(lengthUnit))",
                text: $viewModel.editedWaistCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Thigh circumference
            LightSubHeadline(text: "Thigh circumference")
            
            InputField(
                placeHolder: "Thigh circumference (\(lengthUnit))",
                text: $viewModel.editedThighCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 10)
            
            // MARK: Calf circumference
            LightSubHeadline(text: "Calf circumference")
            
            InputField(
                placeHolder: "Calf circumference (\(lengthUnit))",
                text: $viewModel.editedCalfCirc,
                variant: DecimalIF(
                    min: 0,
                    max: 1000
                )
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 20)
            
        }
        
        // MARK: Save changes button
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
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
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest<BodyEntry> = BodyEntry.fetchRequest()
    
    let results = CoreDataAccess.fetch(context, fetchRequest: fetchRequest)
    
    @State var selectedBodyEntry: BodyEntry? = results.first!
    
    return EditWeighInView(
        selectedBodyEntry: $selectedBodyEntry
    )
    .environment(\.managedObjectContext, context)
}
