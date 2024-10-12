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
        
        let exerciseType = selectedThreshold!.templateSet!.exercise!.exerciseType!
        
        let loadType = selectedThreshold!.templateSet!.loadType!
        
        let quantityType = selectedThreshold!.templateSet!.quantityType!
        
        ScrollView {
            
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
            
            // MARK: Submission alert states.
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
            
            // MARK: Threshold trigger range.
            BoldSubHeadline(text: "Edit the trigger range of the threshold")
                .padding(.top, 20)
            
            HiddenLightSubHeadline(
                title: "What is trigger range?",
                text: "The trigger range is the range of quantity you need to do on this set for this thresholds to trigger. When the threshold triggers the actions you define below will change the set"
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
                    text: $viewModel.editedLowerBound,
                    variant: triggerRangeInputFieldVariant
                )
                
            }
            .padding(.horizontal, 60)
            
            
            HStack {
                
                // MARK: The to input field
                LightSubHeadline(text: "To")
                
                InputField(
                    placeHolder: "upper bound (\(placeHolderUnit))",
                    text: $viewModel.editedUpperBound,
                    variant: triggerRangeInputFieldVariant
                )
                
            }
            .padding(.horizontal, 60)
            
            // MARK: Threshold PR generation.
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
            
            let segments = exerciseType == "reps" ? viewModel.addRepPrSegments : viewModel.addTimePrSegments
            
            // If exercise is rep-based add option to select AMRAP or 1RM pr else only timeMax PR is allowed.
            BasicSegPicker(
                selectedSegment: $viewModel.prSelection,
                segments: segments
            )
            .padding(.horizontal, 40)
            .padding(.top, 5)
            
            // MARK: FLat load add
            BoldSubHeadline(text: "Edit set load change")
                .padding(.top, 20)
            
            if loadType == "numerical" {
                
                HiddenLightSubHeadline(
                    title: "What does change set load mean?",
                    text: "Change load means that when this threshold is triggered the load of the set will be changed with the flat amount you input. This input is optional and it can be negative."
                )
                .padding(.horizontal, 20)
                
                InputField(
                    placeHolder: "Load (\(viewModel.weightUnit(viewContext))",
                    text: $viewModel.editedFlatLoadAdd,
                    variant: DecimalIF(min: 0, max: 10000)
                )
                .padding(.horizontal, 60)
                
            } else {
                
                GroupBox {
                    LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                }
                .padding(.horizontal, 50)
                
            }
            
            // MARK: Flat quantity add
            BoldSubHeadline(text: "Edit set quantity change")
                .padding(.top, 20)
            
            if quantityType == "numerical" {
                
                HiddenLightSubHeadline(
                    title: "What is trigger quantity?",
                    text: "The trigger quantity is the quanity you need to do on your set for this thresholds to trigger. When the threshold triggers the actions you defines below will change your set and/or add a PR. If you have several thresholds only the highest completed one is the one that will be triggered."
                )
                .padding(.horizontal, 20)
                
                let quantityAddInputFieldVariant = viewModel.getTriggerRangeInputFieldVariant(
                    fromExerciseType: exerciseType,
                    min: 0,
                    max: 100000
                )
                
                InputField(
                    placeHolder: "Quantity (\(placeHolderUnit)",
                    text: $viewModel.editedFlatQuantityAdd,
                    variant: quantityAddInputFieldVariant
                )
                .padding(.horizontal, 60)
                
            } else {
                
                GroupBox {
                    
                    LightSubHeadline(text: "Only avaiable if load type is 'Numerical'")
                    
                }
                .padding(.horizontal, 50)
                
            }
            
        }
        
        // MARK: Save changes button
        Button {
            
            if GlobalInputFieldValidator.allFieldsValid() {
                
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
        .padding(.vertical, 20)
            
    }
            
}

#Preview {
    
    let context = PersistenceController.previewViewContext
    
    let fetchRequest: NSFetchRequest<SetThreshold> = SetThreshold.fetchRequest()
    
    let thresholds = CoreDataAccess.fetch(
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
