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
                    if exerciseType == ExerciseType.Reps.rawValue {
                        
                        viewModel.prSelection = PersonalRecordType.OneRepMax.rawValue
                        
                    } else if exerciseType == ExerciseType.Time.rawValue {
                        
                        viewModel.prSelection = PersonalRecordType.TimeMax.rawValue
                        
                    }
                })
            
            Title2(text: "\(selectedTemplateSet!.timePeriodName!)")
                .padding(.bottom, 20)
            
            // MARK: Trigger range
            BoldSubHeadline(text: "Trigger range")
            
            HiddenLightSubHeadline(
                title: "What is trigger range?",
                text: "Thresholds have a bound range of quantity that you need to be within to trigger it. For example if you have a set with 10 reps and a lower / upper bound of 5 and 10 you will trigger the threshold if you complete 5 to 10 reps.",
                alignment: .leading
            )
            .padding(.horizontal, 20)
            
            // Units and variants for the trigger range fields
            let placeHolderUnit = viewModel.getPlaceHolderUnit(fromExerciseType: exerciseType)
            
            let triggerRangeInputFieldVariant = viewModel.getTriggerRangeInputFieldVariant(
                fromExerciseType: exerciseType,
                min: 0,
                max: 100000
            )
            
            HStack {
                
                // MARK: The from input field
                LightSubHeadline(text: "From")
                
                InputField(
                    placeHolder: "lower bound (\(placeHolderUnit))",
                    text: $viewModel.lowerBound,
                    variant: triggerRangeInputFieldVariant
                )
                
            }
            .padding(.horizontal, 60)
            
            
            HStack {
                
                // MARK: The to input field
                LightSubHeadline(text: "To")
                
                InputField(
                    placeHolder: "upper bound (\(placeHolderUnit))",
                    text: $viewModel.upperBound,
                    variant: triggerRangeInputFieldVariant
                )
                
            }
            .padding(.horizontal, 60)
            
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
            
            let segments = exerciseType == ExerciseType.Reps.rawValue ? viewModel.repPrSegments : viewModel.timePrSegments
            
            // If exercise is rep-based add option to select AMRAP or 1RM pr else only timeMax PR is allowed.
            BasicSegPicker(
                selectedSegment: $viewModel.prSelection,
                segments: segments
            )
            .padding(.horizontal, 40)
            .padding(.top, 5)
            
            // MARK: Flat load add option if threshold if the thresholds set has numerical quantity
            BoldSubHeadline(text: "Change set load on trigger?")
                .padding(.top, 20)
            
            if loadType == LoadType.numerical.rawValue {
                
                HiddenLightSubHeadline(
                    title: "What does change load mean?",
                    text: "Change load means that when this threshold is triggered the load of the set will be changed with the flat amount you input. This input is optional and it can be negative.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                InputField(
                    placeHolder: "Load (\(viewModel.weightUnit(viewContext)))",
                    text: $viewModel.flatLoadAdd,
                    variant: DecimalIF(
                        min: 0,
                        max: 10000
                    )
                )
                .padding(.horizontal, 60)
                
            } else {
                
                GroupBox {
                    
                    LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    
                }
                .padding(.horizontal, 50)
                
            }
            
            // MARK: Flat quantity add option if the thresholds set has numerical quantity
            BoldSubHeadline(text: "Change set quantity on trigger?")
                .padding(.top, 20)
            
            if quantityType == QuantityType.numerical.rawValue {
                
                HiddenLightSubHeadline(
                    title: "What does change quantity mean?",
                    text: "Change quantity means that when this threshold is triggered the quantity of the set will be changed with the flat amount you input. This input is optional and it can be negative.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                let quantityAddInputFieldVariant = viewModel.getTriggerRangeInputFieldVariant(
                    fromExerciseType: exerciseType,
                    min: 0,
                    max: 100000
                )
                
                InputField(
                    placeHolder: "Quantity (\(placeHolderUnit))",
                    text: $viewModel.flatQuantityAdd,
                    variant: quantityAddInputFieldVariant
                )
                
            } else {
                
                GroupBox {
                    
                    LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    
                }
                .padding(.horizontal, 50)
                
            }
            
        }
                
        // MARK: Add new threshold button
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
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
