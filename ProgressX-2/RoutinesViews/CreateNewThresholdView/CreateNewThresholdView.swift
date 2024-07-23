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
                
                BoldTitle(text: "Add a new threshold to:  \(selectedTemplateSet!.timePeriodName!)")
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                
                LightSubHeadline(text: "Start by assigning a trigger quantity, when this quantity is achieved during trainig the threshold is triggered.")
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
                
                LightSubHeadline(text: "Here you can select if you want a PR to be added when the threshold is triggered.")
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
                
                BoldSubHeadline(text: "Flat load addition (can be negative)")
                    .padding(.top, 20)
            
                if loadType == "numerical" {
                    LightSubHeadline(text: "Here you can define a flat value that gets added to the sets load if the threshold is triggered")
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
                
                BoldSubHeadline(text: "Flat quantity addition (can be negative)")
                    .padding(.top, 20)
                
                if quantityType == "numerical" {
                    LightSubHeadline(text: "Here you can define a flat value that gets added to the sets quantity if the threshold is triggered")
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
            triggerQuantityFieldValidator = IntFieldValidator()
        } else {
            flatQuantityAddFieldValidator = DoubleFieldValidator(emptyAllowed: true)
            triggerQuantityFieldValidator = DoubleFieldValidator()
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
