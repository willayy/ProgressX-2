//
//  EditThresholdsView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI
import CoreData

struct EditThresholdsView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedThreshold: SetThreshold?
    @StateObject private var viewModel = EditThresholdsViewModel()
    
    var body: some View {
        
        let exerciseType = selectedThreshold!.templateSet!.exercise!.exerciseType
        let loadType = selectedThreshold!.templateSet!.loadType!
        let quantityType = selectedThreshold!.templateSet!.quantityType!
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView {
            VStack {
                
                BoldTitle(
                    text: "Editing: \(selectedThreshold?.timePeriodName ?? "")"
                )
                
                LightSubHeadline(
                    text: "Here you can edit thresholds you have created"
                )
                .padding(.horizontal, 20)
                
                if viewModel.showThresholdChangedAlert {
                    SubmitAlert(
                        message: "Successfully edited threshold!",
                        color: .green,
                        showAlertState: $viewModel.showThresholdChangedAlert
                    )
                } else if viewModel.showNoChangeAlert {
                    SubmitAlert(
                        message: "No change!",
                        color: .blue,
                        showAlertState: $viewModel.showNoChangeAlert
                    )
                }
                
                LightSubHeadline(
                    text: "Edit the trigger quantity of the threshold"
                )
                .padding(.top, 20)
                
                if exerciseType == "reps" {
                    InputIntegerNumberField(
                        placeHolder: "New quantity (reps)", 
                        allowNegatives: false,
                        numberText: $viewModel.editedTriggerQuantity,
                        markAsWrong: $viewModel.editedTriggerQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.editedTriggerQuantityIsInvalidMsg
                    )
                } else {
                    InputDecimalNumberField(
                        placeHolder: "New quantity (seconds)", 
                        allowNegatives: false,
                        numberText: $viewModel.editedTriggerQuantity,
                        markAsWrong: $viewModel.editedTriggerQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.editedTriggerQuantityIsInvalidMsg
                    )
                }
                                
                BoldSubHeadline(text: "Modify PR generation")
                    .padding(.top, 20)
                
                BasicSegPicker(
                    selectedSegment: $viewModel.addPrSelection,
                    segments: viewModel.addPrSegments,
                    frameWidth: 250,
                    horizontalPadding: 40
                )
                
                // If exercise is rep-based add option to select AMRAP or 1RM pr.
                if exerciseType == "reps" && viewModel.addPrSelection == "Add PR"  {
                    BasicSegPicker(
                        selectedSegment: $viewModel.addRepPrSelection,
                        segments: viewModel.addRepPrSegments,
                        frameWidth: 240,
                        horizontalPadding: 40
                    )
                    .padding(.top, 5)
                }
                
                BoldSubHeadline(text: "Edit flat load addition (can be negative)")
                    .padding(.top, 20)
            
                if loadType == "numerical" {
                    LightSubHeadline(text: "Edit the flat load added to this threshold if the trigger quantity is reached")
                        .padding(.horizontal, 20)
                    
                    InputDecimalNumberField(
                        placeHolder: "Load (\(weightUnit))",
                        allowNegatives: true,
                        numberText: $viewModel.editedFlatLoadAdd,
                        markAsWrong: $viewModel.editedFlatLoadAddIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.editedFlatLoadAddIsInvalidMsg
                    )
                } else {
                    GroupBox {
                        LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    }
                    .padding(.horizontal, 50)
                }
                
                BoldSubHeadline(text: "Edit flat quantity addition (can be negative)")
                    .padding(.top, 20)
                
                if quantityType == "numerical" {
                    
                    LightSubHeadline(text: "Edit the flat quantity added to this threshold if the trigger quantity is reached")
                        .padding(.horizontal, 20)
                    
                    if exerciseType == "reps" {
                        
                        InputIntegerNumberField(
                            placeHolder: "Quantity (reps)", 
                            allowNegatives: true,
                            numberText: $viewModel.editedFlatQuantityAdd,
                            markAsWrong: $viewModel.editedFlatQuantityAddIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedFlatQuantityAddIsInvalidMsg
                        )
                        
                    } else if exerciseType == "time" {
                        
                        InputDecimalNumberField(
                            placeHolder: "Quantity (seconds)", 
                            allowNegatives: true,
                            numberText: $viewModel.editedFlatQuantityAdd,
                            markAsWrong: $viewModel.editedFlatQuantityAddIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedFlatQuantityAddIsInvalidMsg
                        )
                        
                    } else {
                        GroupBox {
                            LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                        }
                        .padding(.horizontal, 50)
                    }
                }
                
                Button {
                    if validateInput() {
                        viewModel.saveSetThresholdChanges(
                            context: viewContext,
                            selectedSetThreshold: selectedThreshold!
                        )
                    }
                } label: {
                    Text("Save changes to threshold")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                
            }
        }
        .onAppear(perform: {
            viewModel.setViewStartValues(
                selectedSetThreshold: selectedThreshold!
            )
        })
    }
    
    private func validateInput() -> Bool {
        
        var valid: Int = 0
        
        let exerciseType = selectedThreshold!.templateSet!.exercise!.exerciseType
        
        let flatLoadAddFieldValidator = DoubleFieldValidator(emptyAllowed: true)
        
        let flatQuantityAddFieldValidator: InputFieldValidator
        
        let triggerQuantityFieldValidator: InputFieldValidator
        
        if exerciseType == "reps" {
            flatQuantityAddFieldValidator = IntFieldValidator(emptyAllowed: true)
            triggerQuantityFieldValidator = IntFieldValidator()
        } else {
            flatQuantityAddFieldValidator = DoubleFieldValidator(emptyAllowed: true)
            triggerQuantityFieldValidator = DoubleFieldValidator()
        }
        
        valid += flatLoadAddFieldValidator.valideField(
            inputVar: viewModel.editedFlatLoadAdd,
            errorMessage: $viewModel.editedFlatLoadAddIsInvalidMsg,
            fieldInvalid: $viewModel.editedFlatLoadAddIsInvalid
        )
        
        valid += flatQuantityAddFieldValidator.valideField(
            inputVar: viewModel.editedFlatQuantityAdd,
            errorMessage: $viewModel.editedFlatQuantityAddIsInvalidMsg,
            fieldInvalid: $viewModel.editedFlatQuantityAddIsInvalid
        )
        
        valid += triggerQuantityFieldValidator.valideField(
            inputVar: viewModel.editedTriggerQuantity,
            errorMessage: $viewModel.editedTriggerQuantityIsInvalidMsg,
            fieldInvalid: $viewModel.editedTriggerQuantityIsInvalid
        )
        
        return valid == 0
    }
    
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    let fetchRequest: NSFetchRequest<SetThreshold> = SetThreshold.fetchRequest()
    let thresholds = PersistenceController.fetch(
        context,
        fetchRequest: fetchRequest
    )
    
    @State var navPath: [Int] = [Int]()
    @State var selectedThreshold: SetThreshold? = thresholds.first
    
    return EditThresholdsView(
        navPath: $navPath,
        selectedThreshold: $selectedThreshold
    )
    .environment(\.managedObjectContext, context)
}
