//
//  CreateNewThresholdView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-04.
//

import SwiftUI
import CoreData

struct CreateNewThresholdView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedTemplateSet: TemplateSet?
    @StateObject private var viewModel = CreateNewThresholdViewModel()
    
    var body: some View {
        
        let exerciseType = selectedTemplateSet!.exercise!.exerciseType!
        let loadType = selectedTemplateSet!.loadType!
        let quantityType = selectedTemplateSet!.quantityType!
        let weightUnit = PersistenceController.getWeightUnit(viewContext)!
        
        ScrollView {
            VStack {
                
                BoldTitle(text: "Add a new threshold to")
                    .padding(.horizontal, 20)
                
                Title2(text: "\(selectedTemplateSet!.timePeriodName!)")
                    .padding(.bottom, 20)
                    
                BoldSubHeadline(text: "Trigger quantity")
                
                HiddenLightSubHeadline(
                    title: "What is trigger quantity?",
                    text: "The trigger quantity is the quanity you need to do on your set for this thresholds to trigger. When the threshold triggers the actions you defines below will change your set and/or add a PR."
                )
                .padding(.horizontal, 20)
                
                if exerciseType == "reps" {
                    InputIntegerNumberField(
                        placeHolder: "Triggered at (reps)", 
                        allowNegatives: false,
                        numberText: $viewModel.triggerQuantity,
                        markAsWrong: $viewModel.triggerQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.triggerQuantityIsInvalidMSg
                    )
                } else if exerciseType == "time" {
                    InputDecimalNumberField(
                        placeHolder: "Triggered at (seconds)", 
                        allowNegatives: false,
                        numberText: $viewModel.triggerQuantity,
                        markAsWrong: $viewModel.triggerQuantityIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.triggerQuantityIsInvalidMSg
                    )
                }
                
                BoldSubHeadline(text: "Add a PR")
                    .padding(.top, 20)
                
                HiddenLightSubHeadline(
                    title: "What does add a PR mean?",
                    text: "Add a PR means that when this threshold is triggered a PR will be generated on this sets exercise with the quantity and load you did on the set."
                )
                .padding(.horizontal, 20)
                
                // Add PR when threshold is triggered?
                BasicSegPicker(
                    selectedSegment: $viewModel.addPrSelection,
                    segments: viewModel.addPrSegments,
                    frameWidth: 240,
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
                
                BoldSubHeadline(text: "Change set load")
                    .padding(.top, 20)
            
                if loadType == "numerical" {
                    HiddenLightSubHeadline(
                        title: "What does change load mean?",
                        text: "Change load means that when this threshold is triggered the load of the set will be changed with the flat amount you input. This input is optional and it can be negative."
                    )
                    .padding(.horizontal, 20)
                    
                    InputDecimalNumberField(
                        placeHolder: "Load (\(weightUnit))", 
                        allowNegatives: true,
                        numberText: $viewModel.flatLoadAdd,
                        markAsWrong: $viewModel.flatLoadAddIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.flatLoadAddIsInvalidMsg
                    )
                } else {
                    GroupBox {
                        LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    }
                    .padding(.horizontal, 50)
                }
                
                BoldSubHeadline(text: "Change set quantity")
                    .padding(.top, 20)
                
                if quantityType == "numerical" {
                    HiddenLightSubHeadline(
                        title: "What does change quantity mean?",
                        text: "Change quantity means that when this threshold is triggered the quantity of the set will be changed with the flat amount you input. This input is optional and it can be negative."
                    )
                    .padding(.horizontal, 20)
                    
                    if exerciseType == "reps" {
                        InputIntegerNumberField(
                            placeHolder: "Quantity (reps)", 
                            allowNegatives: true,
                            numberText: $viewModel.flatQuantityAdd,
                            markAsWrong: $viewModel.flatLoadAddIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.flatLoadAddIsInvalidMsg
                        )
                    } else if exerciseType == "time" {
                        InputDecimalNumberField(
                            placeHolder: "Quantity (seconds)", 
                            allowNegatives: true,
                            numberText: $viewModel.flatQuantityAdd,
                            markAsWrong: $viewModel.flatLoadAddIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.flatLoadAddIsInvalidMsg
                        )
                    }
                } else {
                    GroupBox {
                        LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    }
                    .padding(.horizontal, 50)
                }
                
                Button {
                    if validateInput() {
                        viewModel.addNewThreshold(
                            viewContext: viewContext,
                            selectedTemplateSet: selectedTemplateSet!
                        )
                        navPath.removeLast()
                    }
                } label: {
                    Text("Add new Threshold")
                        .frame(height: 40)
                        .foregroundColor(Color("buttonTextColor"))
                    Image(systemName: "plus")
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
        
        let exerciseType = selectedTemplateSet!.exercise!.exerciseType
        
        let flatLoadAddFieldValidator = IntFieldValidator(emptyAllowed: true)
        
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
            inputVar: viewModel.flatLoadAdd,
            errorMessage: $viewModel.flatLoadAddIsInvalidMsg,
            fieldInvalid: $viewModel.flatLoadAddIsInvalid
        )
        
        valid += flatQuantityAddFieldValidator.valideField(
            inputVar: viewModel.flatQuantityAdd,
            errorMessage: $viewModel.flatQuantityAddIsInvalidMsg,
            fieldInvalid: $viewModel.flatQuantityAddIsInvalid
        )
        
        valid += triggerQuantityFieldValidator.valideField(
            inputVar: viewModel.triggerQuantity,
            errorMessage: $viewModel.triggerQuantityIsInvalidMSg,
            fieldInvalid: $viewModel.triggerQuantityIsInvalid
        )
        
        return valid == 0
    }
    
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    let fetchReqeust: NSFetchRequest = TemplateSet.fetchRequest()
    let templateSets = PersistenceController.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSet: TemplateSet? = templateSets.first
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewThresholdView(
        navPath: $navPath, 
        selectedTemplateSet: $selectedTemplateSet
    )
    .environment(\.managedObjectContext, context)
}
