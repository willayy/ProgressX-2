//
//  EditTemplateSetView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-03.
//

import SwiftUI
import CoreData

struct EditTemplateSetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @Binding var selectedTemplateSet: TemplateSet?
    @StateObject private var viewModel = EditTemplateSetViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                
                BoldTitle(text: "Editing: \(selectedTemplateSet!.timePeriodName!)")
                    .padding(.bottom, 10)
                
                if viewModel.showSetChangedAlert {
                    SubmitAlert(
                        message: "Successfully edited set!",
                        color: .green,
                        showAlertState: $viewModel.showSetChangedAlert
                    )
                } else if viewModel.showNoChangeAlert {
                    SubmitAlert(
                        message: "No change!",
                        color: .blue,
                        showAlertState: $viewModel.showNoChangeAlert
                    )
                }
                
                LightSubHeadline(text: "Change name or description")
                
                InputTextField(
                    placeHolder: "New set name",
                    text: $viewModel.editedSetName,
                    maxChars: 25,
                    markAsWrong: $viewModel.editedSetNameIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedSetNameIsInvalidMsg
                )
                .padding(.bottom, 5)
                
                InputTextField(
                    placeHolder: "New set description",
                    text: $viewModel.editedSetDesc,
                    maxChars: 200,
                    markAsWrong: $viewModel.editedSetDescIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedSetDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                LightSubHeadline(text: "By clicking this you can view and edit thresholds for this set")
                    .padding(.horizontal, 10)
                
                Button {
                    navPath.append(8)
                } label: {
                    Text("View thresholds")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change position of the set in it's session")
                
                IntSelectionList(
                    selected: $viewModel.editedSetPositionIndex,
                    selections: viewModel.positionIndexes(
                        selectedTemplateSet: selectedTemplateSet
                    )
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change the exercise of the set")
                
                SetExerciseSelectionList(
                    selectedExercise: $viewModel.selectedExercise,
                    searchWord: $viewModel.searchWord
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change the rest time of the set")
                
                InputDecimalNumberField(
                    placeHolder: "Rest time",
                    allowNegatives: false,
                    numberText: $viewModel.editedRestTime,
                    markAsWrong: $viewModel.editedRestTimeIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change the load type of the set")
                
                StringSelectionList(
                    selected: $viewModel.editedLoadType,
                    selections: viewModel.loadTypeSelections()
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change the quantity type of the set")
                
                StringSelectionList(
                    selected: $viewModel.editedQuantityType,
                    selections: viewModel.quantityTypeSelections()
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Change the quantity or load of the set")
                
                HStack {
                    InputDecimalNumberField(
                        placeHolder: viewModel.loadPlaceholder(
                            viewContext: viewContext
                        ), 
                        allowNegatives: false,
                        numberText: $viewModel.editedSetLoad,
                        markAsWrong: $viewModel.editedSetLoadIsInvalid,
                        width: 0.6,
                        errorMessage: $viewModel.editedSetLoadIsInvalidMsg
                    )
                    
                    if viewModel.loadPlaceholder(viewContext: viewContext) == "Percentage" {
                        Text("%")
                    }
                }
                
                if viewModel.selectedExercise?.exerciseType == "reps" {
                    HStack {
                        InputIntegerNumberField(
                            placeHolder: viewModel.quantityPlaceholder(),
                            allowNegatives: false,
                            numberText: $viewModel.editedSetQuantity,
                            markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        
                        if viewModel.quantityPlaceholder() == "Percentage" {
                            Text("%")
                        }
                    }
                } else {
                    HStack {
                        InputDecimalNumberField(
                            placeHolder: viewModel.quantityPlaceholder(), 
                            allowNegatives: false,
                            numberText: $viewModel.editedSetQuantity,
                            markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        
                        if viewModel.quantityPlaceholder() == "Percentage" {
                            Text("%")
                        }
                    }
                }
                
                Button {
                    if validateInput() {
                        viewModel.saveTemplateSetChanges(
                            viewContext: viewContext,
                            selectedTemplateSet: selectedTemplateSet!
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
        .onAppear(perform: {
            viewModel.setViewStartValues(selectedTemplateSet: selectedTemplateSet!)
        })
    }
    
    private func validateInput() -> Bool {
        let exerciseType = viewModel.selectedExercise!.exerciseType
        let quantityValidator: InputFieldValidator
        
        if exerciseType == "reps" {
            quantityValidator = IntFieldValidator(maxInputNumber: 100000)
        } else {
            quantityValidator = DoubleFieldValidator(maxInputNumber: 100000)
        }
        let restTimeValidator = DoubleFieldValidator(maxInputNumber: 600)
        let loadValidator = DoubleFieldValidator(maxInputNumber: 10000)
        let nameValidator = StringFieldValidator()
        let descValidtor = StringFieldValidator(emptyAllowed: true)
        
        var valid = 0
        
        valid += restTimeValidator.valideField(
            inputVar: viewModel.editedRestTime,
            errorMessage: $viewModel.editedRestTimeIsInvalidMsg,
            fieldInvalid: $viewModel.editedRestTimeIsInvalid
        )
        
        valid += loadValidator.valideField(
            inputVar: viewModel.editedSetLoad,
            errorMessage: $viewModel.editedSetLoadIsInvalidMsg,
            fieldInvalid: $viewModel.editedSetLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: viewModel.editedSetQuantity,
            errorMessage: $viewModel.editedSetQuantityIsInvalidMsg,
            fieldInvalid: $viewModel.editedSetQuantityIsInvalid
        )
        
        valid += nameValidator.valideField(
            inputVar: viewModel.editedSetName,
            errorMessage: $viewModel.editedSetNameIsInvalidMsg,
            fieldInvalid: $viewModel.editedSetNameIsInvalid
        )
        
        valid += descValidtor.valideField(
            inputVar: viewModel.editedSetDesc,
            errorMessage: $viewModel.editedSetDescIsInvalidMsg,
            fieldInvalid: $viewModel.editedSetDescIsInvalid
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

    return EditTemplateSetView(
        navPath: $navPath,
        selectedTemplateSet: $selectedTemplateSet
    )
    .environment(\.managedObjectContext, context)
}
