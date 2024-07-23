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
    
    var body: some View {
        ScrollView {
            VStack {
                
                BoldTitle(text: "Create new set")
                    .padding(.bottom, 10)
                
                LightSubHeadline(text: "Start by optionally giving your set a description or a custom name.")
                    .padding(.bottom, 20)
                
                InputTextField(
                    placeHolder: "Set name",
                    text: $viewModel.newSetName,
                    maxChars: 25,
                    markAsWrong: $viewModel.newSetNameIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.newSetNameIsInvalidMsg
                )
                .padding(.bottom, 5)
                .onAppear(perform: {
                    viewModel.setNewSetName(selectedTemplateSession: selectedTemplateSession)
                })
                
                InputTextField(
                    placeHolder: "Set description",
                    text: $viewModel.newSetDesc,
                    maxChars: 200,
                    markAsWrong: $viewModel.newSetDescIsInvalid,
                    width: 0.6,
                    errorMessage: $viewModel.newSetDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Choose an exercise for the set")
                    .padding(.bottom, 5)
                
                SetExerciseSelectionList(
                    selectedExercise: $viewModel.selectedExercise,
                    searchWord: $viewModel.searchWord
                )
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
                    
                    BoldSubHeadline(text: "Choose load type")
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    if viewModel.selectedLoadType == "Numerical" {
                        LightSubHeadline(text: "Numerical load type means that the load will be a numerical value like 100 kg's or 200 lbs")
                            .padding(.horizontal, 20)
                    } else {
                        LightSubHeadline(text: "Percentage load type means that the load will be a percentage value like, 90% of my current 1RM PR on this exercise or 110% of my current bodyweight")
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: Menu for selecting load type
                    StringSelectionList(
                        selected: $viewModel.selectedLoadType,
                        selections: viewModel.loadTypeSelections
                    )
                    
                    BoldSubHeadline(text: "Choose quantity type")
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    if viewModel.selectedQuantityType == "Numerical" {
                        LightSubHeadline(text: "Numerical quantity type means that the quantity will be a numerical value like 10 seconds or 5 reps.")
                            .padding(.horizontal, 20)
                    } else {
                        LightSubHeadline(text: "Percentage quantity type means that the quantity will be a percentage of the current AMRAP/TimeMax PR")
                            .padding(.horizontal, 20)
                    }
                    
                    // MARK: Menu for selecting quantity type
                    StringSelectionList(
                        selected: $viewModel.selectedQuantityType,
                        selections: viewModel.quantityTypeSelections
                    )
                    
                    BoldSubHeadline(text: "Choose quantity and load")
                        .padding(.top, 20)
                        .padding(.bottom, 5)
                    
                    // MARK: Load inputfield
                    HStack {
                        InputDecimalNumberField(
                            placeHolder: viewModel.loadPlaceholder(
                                viewContext: viewContext
                            ), 
                            allowNegatives: false,
                            numberText: $viewModel.newSetLoad,
                            markAsWrong: $viewModel.newSetLoadIsInvalid,
                            width: 0.6,
                            errorMessage: $viewModel.newSetLoadIsInvalidMsg
                        )
                        
                        if viewModel.loadPlaceholder(viewContext: viewContext) == "Percentage" {
                            Text("%")
                        }
                    }
                    
                    // MARK: Quantity
                    /* Shared quantity input field variable but with different
                     InputFields depending on the exercise type*/
                    if viewModel.selectedExercise?.exerciseType == "reps" {
                        HStack {
                            InputIntegerNumberField(
                                placeHolder: viewModel.quantityPlaceholder,
                                allowNegatives: false,
                                numberText: $viewModel.newSetQuantity,
                                markAsWrong: $viewModel.newSetQuantityIsInvalid,
                                width: 0.6,
                                errorMessage: $viewModel.newSetQuantityIsInvalidMsg
                            )
                            .padding(.top, 5)
                            
                            if viewModel.quantityPlaceholder == "Percentage" {
                                Text("%")
                            }
                        }
                    } else {
                        HStack {
                            InputDecimalNumberField(
                                placeHolder: viewModel.quantityPlaceholder,
                                allowNegatives: false,
                                numberText: $viewModel.newSetQuantity,
                                markAsWrong: $viewModel.newSetQuantityIsInvalid,
                                width: 0.6,
                                errorMessage: $viewModel.newSetQuantityIsInvalidMsg
                            )
                            .padding(.top, 5)
                            
                            if viewModel.quantityPlaceholder == "Percentage" {
                                Text("%")
                            }
                        }
                    }
                    
                    Button {
                        if validateInput() {
                            selectedTemplateSet = viewModel.createNewTemplateSet(
                                viewContext: viewContext,
                                selectedTemplateSession: selectedTemplateSession
                            )
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
        if exerciseType == "reps" { quantityValidator = IntFieldValidator()}
        else { quantityValidator = DoubleFieldValidator()}
        let loadValidator = DoubleFieldValidator()
        let nameValidator = StringFieldValidator()
        let descValidtor = StringFieldValidator(emptyAllowed: true)
        
        var valid = 0
        
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
    let templateSessions = PersistenceController.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSession: TemplateSession? = templateSessions.first
    @State var navPath: [Int] = [Int]()
    @State var selectedTemplateSet: TemplateSet? = nil
    
    return CreateNewTemplateSetView(
        navPath: $navPath,
        selectedTemplateSession: $selectedTemplateSession,
        selectedTemplateSet: $selectedTemplateSet
    ).environment(\.managedObjectContext, context)
}
