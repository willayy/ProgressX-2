//
//  CreateNewSetView.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-07-01.
//

import SwiftUI
import CoreData

struct CreateNewTemplateSetView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    @StateObject private var viewModel = CreateNewTemplateSetViewModel()
    @Binding var selectedTemplateSession: TemplateSession?
    @Binding var selectedTemplateSet: TemplateSet?
    @State private var addBodyWeightButton: Bool = false
    
    var body: some View {
        
        ScrollView {
            
            VStack {
                
                BoldTitle(text: "Create new set in")
                    .onAppear(perform: {
                        viewModel.selectedTemplateSession = selectedTemplateSession!
                        viewModel.setViewStartValues(viewContext: viewContext)
                    })
                
                Title2(text: "\(selectedTemplateSession!.timePeriodName!)")
                
                HiddenLightSubHeadline(
                    title: "What is a set?",
                    text: "A set consists of an exercise, a quantity and a load. The load could for example be 100kg / 100lbs, quantity could be 10 reps or 100 seconds."
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 10)
                
                BoldSubHeadline(text: "Set name")
                
                InputTextField(
                    placeHolder: "Set name",
                    text: $viewModel.newSetName,
                    markAsWrong: $viewModel.newSetNameIsInvalid,
                    errorMessage: $viewModel.newSetNameIsInvalidMsg,
                    maxChars: 25
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 5)
                
                BoldSubHeadline(text: "Set description")
                
                inputLongTextField(
                    placeHolder: "Set description",
                    text: $viewModel.newSetDesc,
                    markAsWrong: $viewModel.newSetDescIsInvalid,
                    errorMessage: $viewModel.newSetDescIsInvalidMsg,
                    maxChars: 200
                )
                .frame(height: 150)
                .padding(.horizontal, 60)
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Choose an exercise for the set")
                    .padding(.bottom, 5)
                
                SetExerciseSelectionList(
                    selectedExercise: $viewModel.selectedExercise,
                    searchWord: $viewModel.searchWord
                )
                .padding(.horizontal, 50)
                .onChange(
                    of: viewModel.selectedExercise,
                    initial: false
                ) { oldValue, newValue in
                    // Set types to some inital value when exercise is selected
                    viewModel.selectedLoadType = "Numerical"
                    viewModel.selectedQuantityType = "Numerical"
                    withAnimation {
                        viewModel.exerciseHasBeenSelected = true
                    }
                }
            
                if viewModel.exerciseHasBeenSelected {
                    
                    BoldSubHeadline(text: "Choose the rest time after this set")
                        .padding(.top, 20)
                    
                    LightSubHeadline(text: "In seconds")
                        .padding(.bottom, 5)
                    
                    DecimalTextField(
                        placeHolder: "Rest time",
                        numberText: $viewModel.restTime,
                        markAsWrong: $viewModel.restTimeIsInvalid,
                        errorMessage: $viewModel.restTimeIsInvalidMsg
                    )
                    .padding(.horizontal, 60)
                    
                    BoldSubHeadline(text: "Choose load type")
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    if viewModel.selectedLoadType == "Numerical" {
                        HiddenLightSubHeadline(
                            title: "What is Numerical load?",
                            text: "Numerical load type means that the load will be a numerical value like 100 kg's or 200 lbs"
                        )
                        .padding(.horizontal, 20)
                    } else {
                        HiddenLightSubHeadline(
                            title: "What is Percentage load?",
                            text: "Percentage load type means that the load will be a percentage value like, 90% of my current 1RM PR on this exercise or 110% of my current bodyweight"
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: Menu for selecting load type
                    StringSelectionList(
                        selected: $viewModel.selectedLoadType,
                        selections: viewModel.loadTypeSelections
                    )
                    .padding(.horizontal, 50)
                    .onChange(of: viewModel.selectedLoadType, initial: true) { oldValue, newValue in
                        if newValue == "Numerical" {
                            withAnimation { addBodyWeightButton = true }
                        } else {
                            withAnimation { addBodyWeightButton = false }
                        }
                    }
                    
                    BoldSubHeadline(text: "Choose quantity type")
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    if viewModel.selectedQuantityType == "Numerical" {
                        HiddenLightSubHeadline(
                            title: "What is Numerical quantity?",
                            text: "Numerical quantity type means that the quantity will be a numerical value like 10 seconds or 5 reps."
                        )
                        .padding(.horizontal, 20)
                    } else {
                        HiddenLightSubHeadline(
                            title: "What is percentage quantity?",
                            text: "Percentage quantity type means that the quantity will be a percentage of the current AMRAP/TimeMax PR"
                        )
                        .padding(.horizontal, 20)
                    }
                    
                    // MARK: Menu for selecting quantity type
                    StringSelectionList(
                        selected: $viewModel.selectedQuantityType,
                        selections: viewModel.quantityTypeSelections
                    )
                    .padding(.horizontal, 50)
                    
                    BoldSubHeadline(text: "Choose quantity and load")
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    HiddenLightSubHeadline(
                        title: "What is BW?",
                        text: "BW means bodyweight, pressing the BW button will make the load automatically set to your bodyweight."
                    )
                    .padding(.horizontal, 20)
                    
                    // MARK: Load inputfield
                    HStack {
                        DecimalTextField(
                            placeHolder: viewModel.loadPlaceholder(viewContext: viewContext),
                            numberText: $viewModel.newSetLoad,
                            markAsWrong: $viewModel.newSetLoadIsInvalid,
                            errorMessage: $viewModel.newSetLoadIsInvalidMsg,
                            bodyWeightButton: addBodyWeightButton
                        )
                        
                        if viewModel.loadPlaceholder(viewContext: viewContext) == "Percentage" {
                            Text("%")
                        }
                    }
                    .padding(.horizontal, 60)
                    
                    // MARK: Quantity
                    /* Shared quantity input field variable but with different
                     InputFields depending on the exercise type*/
                    if viewModel.selectedExercise?.exerciseType == "reps" {
                        HStack {
                            IntegerTextField(
                                placeHolder: viewModel.quantityPlaceholder,
                                numberText: $viewModel.newSetQuantity,
                                markAsWrong: $viewModel.newSetQuantityIsInvalid,
                                errorMessage: $viewModel.newSetQuantityIsInvalidMsg
                            )
                            .padding(.top, 5)
                            
                            if viewModel.quantityPlaceholder == "Percentage" {
                                Text("%")
                            }
                        }
                        .padding(.horizontal, 60)
                    } else {
                        HStack {
                            DecimalTextField(
                                placeHolder: viewModel.quantityPlaceholder,
                                numberText: $viewModel.newSetQuantity,
                                markAsWrong: $viewModel.newSetQuantityIsInvalid,
                                errorMessage: $viewModel.newSetQuantityIsInvalidMsg
                            )
                            .padding(.top, 5)
                            
                            if viewModel.quantityPlaceholder == "Percentage" {
                                Text("%")
                            }
                        }
                        .padding(.horizontal, 60)
                    }
                    
                    Button {
                        if validateInput() {
                            viewModel.saveEntry(viewContext: viewContext)
                            selectedTemplateSet = viewModel.createdTemplateSet
                        }
                    } label: {
                        Text("Create new set")
                            .frame(height: 40)
                            .foregroundColor(Color("buttonTextColor"))
                        Image(systemName: "plus")
                            .foregroundColor(Color("buttonTextColor"))
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.top, 20)
                    .padding(.bottom, 10)
                    .alert(isPresented: $viewModel.showAddThresholds, content: {
                        Alert(
                            title: Text("Add Thresholds?"),
                            message: Text("Do you want to add some thresholds to this set?"),
                            primaryButton: .default(Text("Yes"), action: {
                                navPath.append(8)
                            }),
                            secondaryButton: .cancel(Text("No"), action: {
                                navPath.removeLast()
                            })
                        )
                    })
                }
            }
        }
    }
    
    private func validateInput() -> Bool {
        let exerciseType = viewModel.selectedExercise!.exerciseType
        let quantityValidator: InputFieldValidator
        
        if exerciseType == "reps" { quantityValidator = IntFieldValidator(maxInputNumber: 100000)}
        else { quantityValidator = DoubleFieldValidator(maxInputNumber: 100000)}
        
        let loadValidator = DoubleFieldValidator(maxInputNumber: 10000)
        let restTimeValidator = DoubleFieldValidator(maxInputNumber: 600)
        let nameValidator = StringFieldValidator()
        let descValidtor = StringFieldValidator(emptyAllowed: true)
        
        var valid = 0
        
        valid += restTimeValidator.valideField(
            inputVar: viewModel.restTime,
            errorMessage: $viewModel.restTimeIsInvalidMsg,
            fieldInvalid: $viewModel.restTimeIsInvalid
        )
        
        valid += loadValidator.valideField(
            inputVar: viewModel.newSetLoad,
            errorMessage: $viewModel.newSetLoadIsInvalidMsg,
            fieldInvalid: $viewModel.newSetLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: viewModel.newSetQuantity,
            errorMessage: $viewModel.newSetQuantityIsInvalidMsg,
            fieldInvalid: $viewModel.newSetQuantityIsInvalid
        )
        
        valid += nameValidator.valideField(
            inputVar: viewModel.newSetName,
            errorMessage: $viewModel.newSetNameIsInvalidMsg,
            fieldInvalid: $viewModel.newSetNameIsInvalid
        )
        
        valid += descValidtor.valideField(
            inputVar: viewModel.newSetDesc,
            errorMessage: $viewModel.newSetDescIsInvalidMsg,
            fieldInvalid: $viewModel.newSetDescIsInvalid
        )
        
        return valid == 0
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    let fetchReqeust: NSFetchRequest = TemplateSession.fetchRequest()
    let templateSessions = CoreDataAccess.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSession: TemplateSession? = templateSessions.first
    @State var navPath: [Int] = [Int]()
    @State var selectedTemplateSet: TemplateSet? = nil
    
    return CreateNewTemplateSetView(
        navPath: $navPath,
        selectedTemplateSession: $selectedTemplateSession,
        selectedTemplateSet: $selectedTemplateSet
    ).environment(\.managedObjectContext, context)
}
