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
                
                InputField(
                    placeHolder: "Set name",
                    text: $viewModel.newSetName,
                    variant: TextIF()
                )
                .padding(.horizontal, 60)
                .padding(.bottom, 5)
                
                BoldSubHeadline(text: "Set description")
                
                LargeInputField(
                    placeHolder: "Set description",
                    text: $viewModel.newSetDesc,
                    variant: TextIF(allowEmpty: true)
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
                    
                    // MARK: Set rest time
                    BoldSubHeadline(text: "Choose the rest time after this set")
                        .padding(.top, 20)
                    
                    LightSubHeadline(text: "In seconds")
                        .padding(.bottom, 5)
                    
                    InputField(
                        placeHolder: "Rest time",
                        text: $viewModel.restTime,
                        variant: DecimalIF(
                            min: 0,
                            max: 6000
                        )
                    )
                    .padding(.horizontal, 60)
                    
                    // MARK: Set load type
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
                        
                        InputField(
                            placeHolder: viewModel.loadPlaceholder(viewContext: viewContext),
                            text: $viewModel.newSetLoad,
                            variant: DecimalIF(
                                min: 0,
                                max: 10000
                            )
                        )
                        
                        if viewModel.loadPlaceholder(viewContext: viewContext) == "Percentage" {
                            Text("%")
                        }
                    }
                    .padding(.horizontal, 60)
                    
                    let exerciseType = viewModel.selectedExercise!.exerciseType
                    
                    let variant = exerciseType == "reps" ? IntegerIF(min: 0, max: 100000) : DecimalIF(min: 0, max: 100000)
                    
                    // MARK: Quantity
                    /* Shared quantity input field variable but with different
                     InputFields depending on the exercise type*/
                    HStack {
                        
                        InputField(
                            placeHolder: viewModel.quantityPlaceholder,
                            text: $viewModel.newSetQuantity,
                            variant: variant
                        )
                        .padding(.top, 5)
                        
                        if viewModel.quantityPlaceholder == "Percentage" {
                            
                            Text("%")
                            
                        }
                    }
                    .padding(.horizontal, 60)
                        
                    // MARK: Create new set button
                    Button {
                        
                        if GlobalInputFieldValidator.allFieldsValid() {
                            
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
                    
                    if viewModel.showSetHasBeenSaved {
                        
                        SubmitAlert(message: "Set has already been created!", color: .blue, showAlertState: $viewModel.showSetHasBeenSaved)
                            .padding(.top, 5)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
}

#Preview {
    
    let context = PersistenceController.previewViewContext
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
