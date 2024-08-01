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
    @State private var addBodyWeightButton: Bool = false
    
    var body: some View {
        ScrollView {
            VStack {
                
                BoldTitle(text: "Editing")
                    .onAppear(perform: {
                        viewModel.setViewStartValues(selectedTemplateSet: selectedTemplateSet!)
                    })
                
                Title2(text: "\(selectedTemplateSet!.timePeriodName!)")
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
                
                BoldSubHeadline(text: "Edit set name")
                
                InputTextField(
                    placeHolder: "Set name",
                    text: $viewModel.editedSetName,
                    markAsWrong: $viewModel.editedSetNameIsInvalid,
                    errorMessage: $viewModel.editedSetNameIsInvalidMsg,
                    maxChars: 25
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 5)
                
                BoldSubHeadline(text: "Edit set description")
                
                inputLongTextField(
                    placeHolder: "Set description",
                    text: $viewModel.editedSetDesc,
                    markAsWrong: $viewModel.editedSetDescIsInvalid,
                    errorMessage: $viewModel.editedSetDescIsInvalidMsg,
                    maxChars: 200
                )
                .frame(height: 150)
                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Edit or add thresholds for this set")
                    .padding(.horizontal, 10)
                
                Button {
                    navPath.append(8)
                } label: {
                    Text("View thresholds")
                        .foregroundColor(Color("buttonTextColor"))
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Edit position of this set in its session")
                
                HiddenLightSubHeadline(
                    title: "What does set position mean?",
                    text: "The position of the set is meant as the sets position relative to other sets in this sesison. This is used to change the order you perform your sets when you do this session.",
                    alignment: .leading
                )
                .padding(.horizontal, 20)
                
                IntSelectionList(
                    selected: $viewModel.editedSetPositionIndex,
                    selections: viewModel.positionIndexes(
                        selectedTemplateSet: selectedTemplateSet
                    )
                )
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
                
                BoldSubHeadline(text: "Edit the exercise of the set")
                
                SetExerciseSelectionList(
                    selectedExercise: $viewModel.selectedExercise,
                    searchWord: $viewModel.searchWord
                )
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
                
                BoldSubHeadline(text: "Edit the rest time of the set")
                
                DecimalTextField(
                    placeHolder: "Rest time",
                    numberText: $viewModel.editedRestTime,
                    markAsWrong: $viewModel.editedRestTimeIsInvalid,
                    errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Edit the load type of the set")
                
                StringSelectionList(
                    selected: $viewModel.editedLoadType,
                    selections: viewModel.loadTypeSelections()
                )
                .onChange(of: viewModel.editedLoadType, initial: true) { oldValue, newValue in
                    if newValue == "Numerical" {
                        withAnimation { addBodyWeightButton = true }
                    } else {
                        withAnimation { addBodyWeightButton = false }
                    }
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
                
                BoldSubHeadline(text: "Edit the quantity type of the set")
                
                StringSelectionList(
                    selected: $viewModel.editedQuantityType,
                    selections: viewModel.quantityTypeSelections()
                )
                .padding(.bottom, 20)
                .padding(.horizontal, 50)
                
                BoldSubHeadline(text: "Edit the load of the set")
                
                HStack {
                    DecimalTextField(
                        placeHolder: viewModel.loadPlaceholder(viewContext: viewContext),
                        numberText: $viewModel.editedSetLoad,
                        markAsWrong: $viewModel.editedSetLoadIsInvalid,
                        errorMessage: $viewModel.editedSetLoadIsInvalidMsg,
                        bodyWeightButton: addBodyWeightButton
                    )
                    
                    if viewModel.loadPlaceholder(viewContext: viewContext) == "Percentage" {
                        Text("%")
                    }
                }
                .padding(.horizontal, 60)
                
                BoldSubHeadline(text: "Edit the quantity of the set")
                    .padding(.top, 5)
                
                if viewModel.selectedExercise?.exerciseType == "reps" {
                    HStack {
                        IntegerTextField(
                            placeHolder: viewModel.quantityPlaceholder(),
                            numberText: $viewModel.editedSetQuantity,
                            markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                            errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                        )
                        
                        if viewModel.quantityPlaceholder() == "Percentage" {
                            Text("%")
                        }
                    }
                    .padding(.horizontal, 60)
                } else {
                    HStack {
                        DecimalTextField(
                            placeHolder: viewModel.quantityPlaceholder(), 
                            numberText: $viewModel.editedSetQuantity,
                            markAsWrong: $viewModel.editedSetQuantityIsInvalid,
                            errorMessage: $viewModel.editedSetQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        
                        if viewModel.quantityPlaceholder() == "Percentage" {
                            Text("%")
                        }
                    }
                    .padding(.horizontal, 60)
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
                
                if viewModel.savingError {
                    SavingErrorText()
                        .padding(.horizontal, 20)
                }
                
            }
        }
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
