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
        
        ScrollView {
            
            VStack {
                
                BoldTitle(text: "Editing")
                    .onAppear(perform: {
                        viewModel.setViewStartValues(entity: selectedThreshold!)
                    })
                
                Title2(text: "\(selectedThreshold!.timePeriodName!)")
                
                LightSubHeadline(
                    text: "Here you can edit thresholds you have created"
                )
                .padding(.top, 5)
                .padding(.horizontal, 20)
                
                if viewModel.showThresholdChangedAlert {
                    SubmitAlert(
                        message: "Successfully edited threshold!",
                        color: .green,
                        showAlertState: $viewModel.showThresholdChangedAlert
                    )
                    .padding(.top, 10)
                } else if viewModel.showNoChangeAlert {
                    SubmitAlert(
                        message: "No change!",
                        color: .blue,
                        showAlertState: $viewModel.showNoChangeAlert
                    )
                    .padding(.top, 10)
                }
                
                BoldSubHeadline(text: "Edit the trigger quantity of the threshold")
                .padding(.top, 20)
                
                HiddenLightSubHeadline(
                    title: "What is trigger quantity?",
                    text: "The trigger quantity is the quanity you need to do on your set for this thresholds to trigger. When the threshold triggers the actions you defines below will change your set and/or add a PR."
                )
                .padding(.horizontal, 20)
                
                if exerciseType == "reps" {
                    IntegerTextField(
                        placeHolder: "New quantity (reps)", 
                        numberText: $viewModel.editedTriggerQuantity,
                        markAsWrong: $viewModel.editedTriggerQuantityIsInvalid,
                        errorMessage: $viewModel.editedTriggerQuantityIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                } else {
                    DecimalTextField(
                        placeHolder: "New quantity (seconds)", 
                        numberText: $viewModel.editedTriggerQuantity,
                        markAsWrong: $viewModel.editedTriggerQuantityIsInvalid,
                        errorMessage: $viewModel.editedTriggerQuantityIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                }
                                
                BoldSubHeadline(text: "Modify PR generation")
                    .padding(.top, 20)
                
                HiddenLightSubHeadline(
                    title: "What does modify PR generation mean?",
                    text: "Add a PR means that when this threshold is triggered a PR will be generated on this sets exercise with the quantity and load you did on the set."
                )
                .padding(.horizontal, 20)
                
                BooleanSegPicker(
                    selectedSegment: $viewModel.addPrSelection,
                    segments: viewModel.addPrSegments
                )
                .padding(.horizontal, 40)
                
                // If exercise is rep-based add option to select AMRAP or 1RM pr.
                if exerciseType == "reps" && viewModel.addPrSelection  {
                    BasicSegPicker(
                        selectedSegment: $viewModel.prSelection,
                        segments: viewModel.addRepPrSegments
                    )
                    .padding(.top, 5)
                    .padding(.horizontal, 40)
                } else if exerciseType == "time" && viewModel.addPrSelection {
                    BasicSegPicker(
                        selectedSegment: $viewModel.prSelection,
                        segments: viewModel.addTimePrSegments
                    )
                    .padding(.top, 5)
                    .padding(.horizontal, 40)
                }
                
                BoldSubHeadline(text: "Edit set load change")
                    .padding(.top, 20)
            
                if loadType == "numerical" {
                    
                    HiddenLightSubHeadline(
                        title: "What does change set load mean?",
                        text: "Change load means that when this threshold is triggered the load of the set will be changed with the flat amount you input. This input is optional and it can be negative."
                    )
                    .padding(.horizontal, 20)
                    
                    DecimalTextField(
                        placeHolder: "Load (\(viewModel.weightUnit(viewContext))",
                        numberText: $viewModel.editedFlatLoadAdd,
                        markAsWrong: $viewModel.editedFlatLoadAddIsInvalid,
                        errorMessage: $viewModel.editedFlatLoadAddIsInvalidMsg,
                        allowNegatives: true
                    )
                    .padding(.horizontal, 60)
                    
                } else {
                    
                    GroupBox {
                        LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    }
                    .padding(.horizontal, 50)
                    
                }
                
                BoldSubHeadline(text: "Edit set quantity change")
                    .padding(.top, 20)
                
                if quantityType == "numerical" {
                    
                    HiddenLightSubHeadline(
                        title: "What does change set quantity mean?",
                        text: "Change quantity means that when this threshold is triggered the quantity of the set will be changed with the flat amount you input. This input is optional and it can be negative."
                    )
                    .padding(.horizontal, 20)
                    
                    if exerciseType == "reps" {
                        
                        IntegerTextField(
                            placeHolder: "Quantity (reps)",
                            numberText: $viewModel.editedFlatQuantityAdd,
                            markAsWrong: $viewModel.editedFlatQuantityAddIsInvalid,
                            errorMessage: $viewModel.editedFlatQuantityAddIsInvalidMsg,
                            allowNegatives: true
                        )
                        .padding(.horizontal, 60)
                        
                    } else if exerciseType == "time" {
                        
                        DecimalTextField(
                            placeHolder: "Quantity (seconds)",
                            numberText: $viewModel.editedFlatQuantityAdd,
                            markAsWrong: $viewModel.editedFlatQuantityAddIsInvalid,
                            errorMessage: $viewModel.editedFlatQuantityAddIsInvalidMsg,
                            allowNegatives: true
                        )
                        .padding(.horizontal, 60)
                        
                    } else {
                        GroupBox {
                            LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                        }
                        .padding(.horizontal, 50)
                    }
                }
                
                Button {
                    if validateInput() {
                        viewModel.saveEdits(
                            entity: selectedThreshold!,
                            viewContext: viewContext
                        )
                    }
                } label: {
                    Text("Save changes to threshold")
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
        
        let exerciseType = selectedThreshold!.templateSet!.exercise!.exerciseType
        
        let flatLoadAddFieldValidator = DoubleFieldValidator(emptyAllowed: true)
        
        let flatQuantityAddFieldValidator: InputFieldValidator
        
        let triggerQuantityFieldValidator: InputFieldValidator
        
        if exerciseType == "reps" {
            flatQuantityAddFieldValidator = IntFieldValidator(emptyAllowed: true)
            triggerQuantityFieldValidator = IntFieldValidator(maxInputNumber: 100000)
        } else {
            flatQuantityAddFieldValidator = DoubleFieldValidator(emptyAllowed: true)
            triggerQuantityFieldValidator = DoubleFieldValidator(maxInputNumber: 100000)
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
