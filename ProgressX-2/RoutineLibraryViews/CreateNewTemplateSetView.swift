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
    @State private var newSetName: String = "Set "
    @State private var newSetNameIsInvalid: Bool = false
    @State private var newSetNameIsInvalidMsg: String = ""
    
    // The Description of the set (Optional)
    @State private var newSetDesc: String = ""
    @State private var newSetDescIsInvalid: Bool = false
    @State private var newSetDescIsInvalidMsg: String = ""
    
    // The Load of the set
    @State private var newSetLoad: String = ""
    @State private var newSetLoadIsInvalid: Bool = false
    @State private var newSetLoadIsInvalidMsg: String = ""
    
    // The Quantity of the set
    @State private var newSetQuantity: String = ""
    @State private var newSetQuantityIsInvalid: Bool = false
    @State private var newSetQuantityIsInvalidMsg: String = ""
    
    // The exercise of the set
    @State private var selectedExercise: Exercise? = nil
    @State private var searchWord: String = ""
    
    // Selection of load types
    @State private var selectedLoadType: String = "Select exercise first!"
    
    // Selection of quantity types
    @State private var selectedQuantityType: String = "Select exercise first!"
    
    // State that tracks if an exercises has been selected
    @State private var exerciseHasBeenSelected: Bool = false
    
    // State that decides if the view should navigate to the add thresholds view
    @State private var showAddThresholds: Bool = false
    
    @Binding var selectedTemplateSession: TemplateSession?
    
    var body: some View {
        
        let nextPositionIndex: Int64 = {
            return selectedTemplateSession!.getNextPositionIndex()
        }()
        
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
                    withAnimation {
                        exerciseHasBeenSelected = true
                    }
                }
            
                if exerciseHasBeenSelected {
                    
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
                                .padding(2)
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
                                .padding(2)
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
                            numberText: $newSetLoad,
                            markAsWrong: $newSetLoadIsInvalid,
                            width: 0.6,
                            errorMessage: $newSetLoadIsInvalidMsg
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
                                numberText: $newSetQuantity,
                                markAsWrong: $newSetQuantityIsInvalid,
                                width: 0.6,
                                errorMessage: $newSetQuantityIsInvalidMsg
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
                                numberText: $newSetQuantity,
                                markAsWrong: $newSetQuantityIsInvalid,
                                width: 0.6,
                                errorMessage: $newSetQuantityIsInvalidMsg
                            )
                            .padding(.top, 5)
                            if selectedQuantityType == "Percentage" {
                                Text("%")
                            }
                        }
                    }
                    
                    Button {
                        if validateInput() {
                            
                            /* Insane computed constant for the input load to the NSManagedObject entity
                             very ugly and i dont want to see it again */
                            let inputLoad: Double = {
                                if selectedLoadType != "Numerical" {
                                    let lastLoad: Double?
                                    
                                    switch selectedLoadType {
                                        
                                    case "Percentage of current 1RM PR":
                                        let latestPr = PersistenceController.getLatestPersonalRecord(
                                            viewContext,
                                            exercise: selectedExercise!,
                                            prType: "onerepmax"
                                        )
                                        lastLoad = latestPr?.weightLoad
                                        
                                    case "Percentage of current TimeMax PR":
                                        let latestPr = PersistenceController.getLatestPersonalRecord(
                                            viewContext,
                                            exercise: selectedExercise!,
                                            prType: "timemax"
                                        )
                                        lastLoad = latestPr?.weightLoad
                                        
                                    case "Percentage of current AMRAP PR":
                                        let latestPr = PersistenceController.getLatestPersonalRecord(
                                            viewContext,
                                            exercise: selectedExercise!,
                                            prType: "maxreps"
                                        )
                                        lastLoad = latestPr?.weightLoad
                                        
                                    case "Percentage of current body weight":
                                        let latestBw = PersistenceController.getLatestBodyEntry(viewContext)
                                        lastLoad = latestBw?.bodyWeight
                                        
                                    default:
                                        lastLoad = 0
                                    }
                                    
                                    let fraction = Double(newSetLoad)! / 100
                                    return fraction * (lastLoad ?? 0)
                                } else {
                                    return Double(newSetLoad)!
                                }
                            }()
                            
                            /* Insane computed constant for the input quantity to the NSManagedObject entity
                             very ugly and i dont want to see it again */
                            let inputQuantity: Double = {
                                if selectedQuantityType != "Numerical" {
                                    let lastQuantity: Double?
                                    
                                    switch selectedQuantityType {
                                        
                                    case "Percentage of current TimeMax PR":
                                        let latestPr = PersistenceController.getLatestPersonalRecord(
                                            viewContext,
                                            exercise: selectedExercise!,
                                            prType: "timemax"
                                        )
                                        lastQuantity = latestPr?.prQuantity
                                        
                                    case "Percentage of current AMRAP PR":
                                        let latestPr = PersistenceController.getLatestPersonalRecord(
                                            viewContext,
                                            exercise: selectedExercise!,
                                            prType: "maxreps"
                                        )
                                        lastQuantity = latestPr?.prQuantity
                                        
                                    default:
                                        lastQuantity = 0
                                    }
                                    
                                    let fraction = Double(newSetQuantity)! / 100
                                    return fraction * (lastQuantity ?? 0)
                                } else {
                                    return Double(newSetQuantity)!
                                }
                            }()
                            
                            _ = PersistenceController.createTemplateSet(
                                viewContext,
                                name: newSetName,
                                templateSession: selectedTemplateSession!,
                                positionIndex: nextPositionIndex,
                                exercise: selectedExercise!,
                                loadType: typeMap[selectedLoadType]!,
                                load: inputLoad,
                                quantityType: typeMap[selectedQuantityType]!,
                                quantity: inputQuantity
                            )
                            
                            #warning("TODO: Try if this shit even works")
                            
                            PersistenceController.save(viewContext)
                            showAddThresholds = true
                            
                            navPath.append(8)
                        }
                    } label: {
                        Text("Create set")
                            .frame(height: 40)
                        Image(systemName: "plus")
                    }
                    .buttonStyle(BorderedProminentButtonStyle())
                    .padding(.top, 20)
                    .alert(isPresented: $showAddThresholds, content: {
                        Alert(
                            title: Text("Add Thresholds?"),
                            message: Text("Do you want to add some thresholds to this set?"),
                            primaryButton: .default(Text("Yes"), action: {
                                navPath.append(8)
                            }),
                            secondaryButton: .cancel(Text("No"))
                        )
                    })
                }
            }
        }
    }
    
    private func validateInput() -> Bool {
        let exerciseType = selectedExercise!.exerciseType
        let quantityValidator: InputFieldValidator
        if exerciseType == "reps" { quantityValidator = IntFieldValidator()}
        else { quantityValidator = DoubleFieldValidator()}
        let loadValidator = DoubleFieldValidator()
        let nameValidator = StringFieldValidator()
        let descValidtor = StringFieldValidator(emptyAllowed: true)
        
        var valid = 0
        
        valid += loadValidator.valideField(
            inputVar: newSetLoad,
            errorMessage: $newSetLoadIsInvalidMsg,
            fieldInvalid: $newSetLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: newSetQuantity,
            errorMessage: $newSetQuantityIsInvalidMsg,
            fieldInvalid: $newSetQuantityIsInvalid
        )
        
        valid += nameValidator.valideField(
            inputVar: newSetName,
            errorMessage: $newSetNameIsInvalidMsg,
            fieldInvalid: $newSetNameIsInvalid
        )
        
        valid += descValidtor.valideField(
            inputVar: newSetDesc,
            errorMessage: $newSetDescIsInvalidMsg,
            fieldInvalid: $newSetDescIsInvalid
        )
        
        return valid == 0
    }
    
    /* This dictionary maps the entered value from the view to the correct core data property value */
    let typeMap: [String : String] = [
        "Numerical" : "numerical",
        "Percentage of current 1RM PR" : "maxperc",
        "Percentage of current TimeMax PR" : "maxperc",
        "Percentage of current AMRAP PR" : "maxperc",
        "Percentage of current body weight" : "bwperc"
    ]
    
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
