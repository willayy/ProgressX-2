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
    
    // The Name of the set (good default is provided)
    @State var newSetName: String = "Set "
    @State var newSetNameIsInvalid: Bool = false
    @State var newSetNameIsInvalidMsg: String = ""
    
    // The Description of the set (Optional)
    @State var newSetDesc: String = ""
    @State var newSetDescIsInvalid: Bool = false
    @State var newSetDescIsInvalidMsg: String = ""
    
    // The Load of the set
    @State var setLoad: String = ""
    @State var setLoadIsInvalid: Bool = false
    @State var setLoadIsInvalidMsg: String = ""
    
    // The Quantity of the set
    @State var setQuantity: String = ""
    @State var setQuantityIsInvalid: Bool = false
    @State var setQuantityIsInvalidMsg: String = ""
    
    // The exercise of the set
    @State var selectedExercise: Exercise? = nil
    @State var searchWord: String = ""
    
    // Selection of load types
    @State var selectedLoadType: String = "Select exercise first!"
    
    // Selection of quantity types
    @State var selectedQuantityType: String = "Select exercise first!"
    
    @Binding var selectedTemplateSession: TemplateSession?
    
    var body: some View {
        
        // Computed constants for load type selections
        let loadTypeSelections: [String] = {
            switch selectedExercise?.exerciseType {
            case "reps":
                return ["Numerical",
                        "Percentage of current 1RM PR",
                        "Percentage of current body weight"]
            case "time":
                return ["Numerical",
                        "Percentage of current TimeMax PR",
                        "Percentage of current body weight"]
            default:
                return []
            }
        }()
        
        // Computed constants for quantity type selections
        let quantityTypeSelections: [String] = {
            switch selectedExercise?.exerciseType {
            case "reps":
                return ["Numerical",
                        "Percentage of current AMRAP PR"]
            case "time":
                return ["Numerical",
                        "Percentage of current TimeMax PR"]
            default:
                return []
            }
        }()
        
        // Computed variable for the load placeholder
        var loadPlaceholder: String {
            switch selectedLoadType {
            case "Numerical":
                let weightUnit = PersistenceController.getWeightUnit(viewContext)!
                return "Load \(weightUnit)"
            case "Percentage of current 1RM PR":
                return "Percentage"
            case "Percentage of current TimeMax PR":
                return "Percentage"
            case "Percentage of current body weight":
                return "Percentage"
            default:
                return "Select exercise first!"
            }
        }
        
        // Computed variable for the quantity placeholder
        var quantityPlaceholder: String {
            switch selectedQuantityType {
            case "Numerical":
                let exerciseType = selectedExercise?.exerciseType
                if exerciseType == nil {return "Select exercise first!"}
                return exerciseType == "reps" ? "Reps" : "Seconds"
            case "Percentage of current AMRAP PR":
                return "Percentage"
            case "Percentage of current TimeMax PR":
                return "Percentage"
            default:
                return "Select exercise first!"
            }
        }
        
        ScrollView {
            VStack {
                
                BoldTitle(text: "Create new set")
                    .padding(.bottom, 10)
                
                LightSubHeadline(text: "Start by optionally giving your set a description or a custom name.")
                    .padding(.bottom, 20)
                
                InputShortTextField(
                    placeHolder: "Set name",
                    text: $newSetName,
                    markAsWrong: $newSetNameIsInvalid,
                    width: 0.6,
                    errorMessage: $newSetNameIsInvalidMsg
                )
                .onAppear(perform: {
                    let nextPositionIndex = selectedTemplateSession!.getNextPositionIndex()
                    newSetName = newSetName + String(nextPositionIndex)
                })
                .padding(.bottom, 5)
                
                InputShortTextField(
                    placeHolder: "Set description",
                    text: $newSetDesc,
                    markAsWrong: $newSetDescIsInvalid,
                    width: 0.6,
                    errorMessage: $newSetDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                BoldSubHeadline(text: "Choose an exercise for the set")
                    .padding(.bottom, 5)
                
                SetExerciseSelectionList(
                    selectedExercise: $selectedExercise,
                    searchWord: $searchWord
                )
                .onChange(
                    of: selectedExercise,
                    initial: false
                ) { oldValue, newValue in
                    // Set types to some inital value when exercise is selected
                    selectedLoadType = "Numerical"
                    selectedQuantityType = "Numerical"
                }
                
                BoldSubHeadline(text: "Choose load type")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                
                if selectedLoadType == "Numerical" {
                    LightSubHeadline(text: "Numerical load type means that the load will be a numerical value like 100 kg's or 200 lbs")
                        .padding(.horizontal, 20)
                } else {
                    LightSubHeadline(text: "Percentage load type means that the load will be a percentage value like, 90% of my current 1RM PR on this exercise or 110% of my current bodyweight")
                        .padding(.horizontal, 20)
                }
                
                // MARK: Menu for selecting load type
                GroupBox {
                    DisclosureGroup(selectedLoadType) {
                        ForEach(loadTypeSelections, id: \.self) { loadType in
                            Button {
                                selectedLoadType = loadType
                            } label: {
                                Text(loadType)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
        
                
                BoldSubHeadline(text: "Choose quantity type")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                
                if selectedQuantityType == "Numerical" {
                    LightSubHeadline(text: "Numerical quantity type means that the quantity will be a numerical value like 10 seconds or 5 reps.")
                        .padding(.horizontal, 20)
                } else {
                    LightSubHeadline(text: "Percentage quantity type means that the quantity will be a percentage of the current AMRAP/TimeMax PR")
                        .padding(.horizontal, 20)
                }
                
                // MARK: Menu for selecting quantity type
                GroupBox {
                    DisclosureGroup(selectedQuantityType) {
                        ForEach(quantityTypeSelections, id: \.self) { quantityType in
                            Button {
                                selectedLoadType = quantityType
                            } label: {
                                Text(quantityType)
                            }
                        }
                    }
                }
                .padding(.horizontal, 40)
                
                BoldSubHeadline(text: "Choose quantity and load")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                
                // MARK: Load inputfield
                HStack {
                    InputDecimalNumberField(
                        placeHolder: loadPlaceholder,
                        numberText: $setLoad,
                        markAsWrong: $setLoadIsInvalid,
                        width: 0.6,
                        errorMessage: $setLoadIsInvalidMsg
                    )
                    
                    if loadPlaceholder == "Percentage" {
                        Text("%")
                    }
                }
                
                // MARK: Quantity
                /* Shared quantity input field variable but with different
                 InputFields depending on the exercise type*/
                if selectedExercise?.exerciseType == "reps" {
                    HStack {
                        InputIntegerNumberField(
                            placeHolder: quantityPlaceholder,
                            numberText: $setQuantity,
                            markAsWrong: $setQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $setQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        if selectedQuantityType == "Percentage" {
                            Text("%")
                        }
                    }
                } else {
                    HStack {
                        InputDecimalNumberField(
                            placeHolder: quantityPlaceholder,
                            numberText: $setQuantity,
                            markAsWrong: $setQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $setQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        if selectedQuantityType == "Percentage" {
                            Text("%")
                        }
                    }
                }
                
                Button {
                    if validateInput() {
                        navPath.append(8)
                    }
                } label: {
                    Text("Create set")
                        .frame(height: 40)
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                    
                }
            }
        }
    }

    private func validateInput() -> Bool {
        return false
        //let loadFieldValidator = Dec
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchReqeust: NSFetchRequest = TemplateSession.fetchRequest()
    let templateSessions = PersistenceController.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSession: TemplateSession? = templateSessions.first
    @State var navPath: [Int] = [Int]()
    
    return CreateNewTemplateSetView(
        navPath: $navPath,
        selectedTemplateSession: $selectedTemplateSession
    ).environment(\.managedObjectContext, context)
}
