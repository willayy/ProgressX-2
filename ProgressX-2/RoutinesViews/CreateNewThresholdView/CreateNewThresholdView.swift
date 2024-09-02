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
        
        ScrollView {
            
            BoldTitle(text: "Add a new threshold to")
                .padding(.horizontal, 20)
                .onAppear(perform: {
                    if exerciseType == "reps" {
                        viewModel.prSelection = "onerepmax"
                    } else if exerciseType == "time" {
                        viewModel.prSelection = "timemax"
                    }
                })
            
            Title2(text: "\(selectedTemplateSet!.timePeriodName!)")
                .padding(.bottom, 20)
            
            BoldSubHeadline(text: "Trigger bounds")
            
            HiddenLightSubHeadline(
                title: "What is trigger bounds?",
                text: "Thresholds have a bound range of quantity that you need to be within to trigger it. For example if you have a set with 10 reps and a lower / upper bound of 5 and 10 you will trigger the threshold if you complete 5 to 10 reps.",
                alignment: .leading
            )
            .padding(.horizontal, 20)
            
            if exerciseType == "reps" {
                
                IntegerTextField(
                    placeHolder: "lower bound (reps)",
                    numberText: $viewModel.lowerBound,
                    markAsWrong: $viewModel.lowerBoundIsInvalid,
                    errorMessage: $viewModel.lowerBoundIsInvalidMSg
                )
                .padding(.horizontal, 60)
                
                IntegerTextField(
                    placeHolder: "upper bound (reps)",
                    numberText: $viewModel.upperBound,
                    markAsWrong: $viewModel.upperBoundIsInvalid,
                    errorMessage: $viewModel.upperBoundIsInvalidMSg
                )
                .padding(.horizontal, 60)
                
            } else if exerciseType == "time" {
                
                DecimalTextField(
                    placeHolder: "lower bound (seconds)",
                    numberText: $viewModel.lowerBound,
                    markAsWrong: $viewModel.lowerBoundIsInvalid,
                    errorMessage: $viewModel.lowerBoundIsInvalidMSg
                )
                .padding(.horizontal, 60)
                
                DecimalTextField(
                    placeHolder: "upper bound (seconds)",
                    numberText: $viewModel.upperBound,
                    markAsWrong: $viewModel.upperBoundIsInvalid,
                    errorMessage: $viewModel.upperBoundIsInvalidMSg
                )
                .padding(.horizontal, 60)
                
            }
            
            BoldSubHeadline(text: "Add a PR")
                .padding(.top, 20)
            
            HiddenLightSubHeadline(
                title: "What does add a PR mean?",
                text: "Add a PR means that when this threshold is triggered a PR will be generated on this sets exercise with the quantity and load you did on the set.",
                alignment: .leading
            )
            .padding(.horizontal, 20)
            
            // Add PR when threshold is triggered?
            BooleanSegPicker(
                selectedSegment: $viewModel.addPrSelection,
                segments: viewModel.addPrSegments
            )
            .padding(.horizontal, 40)
            
            // If exercise is rep-based add option to select AMRAP or 1RM pr.
            if exerciseType == "reps" && viewModel.addPrSelection {
                
                BasicSegPicker(
                    selectedSegment: $viewModel.prSelection,
                    segments: viewModel.repPrSegments
                )
                .padding(.horizontal, 40)
                .padding(.top, 5)
                
            } else if exerciseType == "time" && viewModel.addPrSelection {
                
                BasicSegPicker(
                    selectedSegment: $viewModel.prSelection,
                    segments: viewModel.timePrSegments
                )
                .padding(.horizontal, 40)
                .padding(.top, 5)
                
            }
            
            BoldSubHeadline(text: "Change set load on trigger?")
                .padding(.top, 20)
            
            if loadType == "numerical" {
                
                HiddenLightSubHeadline(
                    title: "What does change load mean?",
                    text: "Change load means that when this threshold is triggered the load of the set will be changed with the flat amount you input. This input is optional and it can be negative.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                DecimalTextField(
                    placeHolder: "Load (\(viewModel.weightUnit(viewContext)))",
                    numberText: $viewModel.flatLoadAdd,
                    markAsWrong: $viewModel.flatLoadAddIsInvalid,
                    errorMessage: $viewModel.flatLoadAddIsInvalidMsg,
                    allowNegatives: true
                )
                .padding(.horizontal, 60)
                
            } else {
                
                GroupBox {
                    LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                }
                .padding(.horizontal, 50)
                
            }
            
            BoldSubHeadline(text: "Change set quantity on trigger?")
                .padding(.top, 20)
            
            if quantityType == "numerical" {
                
                HiddenLightSubHeadline(
                    title: "What does change quantity mean?",
                    text: "Change quantity means that when this threshold is triggered the quantity of the set will be changed with the flat amount you input. This input is optional and it can be negative.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                if exerciseType == "reps" {
                    
                    IntegerTextField(
                        placeHolder: "Quantity (reps)",
                        numberText: $viewModel.flatQuantityAdd,
                        markAsWrong: $viewModel.flatLoadAddIsInvalid,
                        errorMessage: $viewModel.flatLoadAddIsInvalidMsg,
                        allowNegatives: true
                    )
                    .padding(.horizontal, 60)
                    
                } else if exerciseType == "time" {
                    
                    DecimalTextField(
                        placeHolder: "Quantity (seconds)",
                        numberText: $viewModel.flatQuantityAdd,
                        markAsWrong: $viewModel.flatLoadAddIsInvalid,
                        errorMessage: $viewModel.flatLoadAddIsInvalidMsg,
                        allowNegatives: true
                    )
                    .padding(.horizontal, 60)
                    
                }
                
            } else {
                
                GroupBox {
                    LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                }
                .padding(.horizontal, 50)
                
            }
            
        }
                
        Button {
            if validateInput() {
                viewModel.selectedTemplateSet = selectedTemplateSet
                viewModel.saveEntry(viewContext: viewContext)
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
        .padding(.vertical, 20)
    }
    
    private func validateInput() -> Bool {
        
        var valid: Int = 0
        
        let exerciseType = selectedTemplateSet!.exercise!.exerciseType
        
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
            inputVar: viewModel.lowerBound,
            errorMessage: $viewModel.lowerBoundIsInvalidMSg,
            fieldInvalid: $viewModel.lowerBoundIsInvalid
        )
        
        valid += triggerQuantityFieldValidator.valideField(
            inputVar: viewModel.upperBound,
            errorMessage: $viewModel.upperBoundIsInvalidMSg,
            fieldInvalid: $viewModel.upperBoundIsInvalid
        )
        
        return valid == 0
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    let fetchReqeust: NSFetchRequest = TemplateSet.fetchRequest()
    let templateSets = CoreDataAccess.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSet: TemplateSet? = templateSets.first
    
    @State var navPath: [Int] = [Int]()
    
    return CreateNewThresholdView(
        navPath: $navPath, 
        selectedTemplateSet: $selectedTemplateSet
    )
    .environment(\.managedObjectContext, context)
}
