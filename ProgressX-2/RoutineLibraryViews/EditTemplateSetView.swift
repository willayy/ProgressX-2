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
    
    // The Name of the set (good default is provided)
    @State private var editedSetName: String = ""
    @State private var editedSetNameIsInvalid: Bool = false
    @State private var editedSetNameIsInvalidMsg: String = ""
    
    // The Description of the set (Optional)
    @State private var editedSetDesc: String = ""
    @State private var editedSetDescIsInvalid: Bool = false
    @State private var editedSetDescIsInvalidMsg: String = ""
    
    // The Load of the set
    @State private var editedSetLoad: String = ""
    @State private var editedSetLoadIsInvalid: Bool = false
    @State private var editedSetLoadIsInvalidMsg: String = ""
    
    // The Quantity of the set
    @State private var editedSetQuantity: String = ""
    @State private var editedSetQuantityIsInvalid: Bool = false
    @State private var editedSetQuantityIsInvalidMsg: String = ""
    
    // The PositionIndex of the set
    @State private var editedSetPositionIndex: Int64 = 0
    
    // The load type of the set
    @State private var editedLoadType: String = ""
    
    // The quantity type of the set
    @State private var editedQuantityType: String = ""
    
    // Edit the exercise of the set
    @State private var searchWord: String = ""
    @State private var selectedExercise: Exercise? = nil
    
    // Change alert states
    @State private var showNoChangeAlert: Bool = false
    @State private var showSetChangedAlert: Bool = false
    
    var body: some View {
        
        // Find all the positionIndexes of the other set-children of this sets session
        let positionIndexes: [Int64] = {
            let session = selectedTemplateSet!.templateSession!
            let sets = session.templateSets!.allObjects as! [TemplateSet]
            let positionIndexes = sets.map { set in
                set.positionIndex
            }
            return positionIndexes
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
        
        // This computed constant maps NSManagedObject attributes to the correct display value
        let loadTypeMap: [String : String] = {
            if selectedExercise?.exerciseType == "reps" {
                return [
                    "numerical" : "Numerical",
                    "maxperc" : "Percentage of current 1RM PR",
                    "bwperc" : "Percentage of current body weight"
                ]
            } else {
                return [
                    "maxperc" : "Percentage of current TimeMax PR" ,
                    "numerical" : "Numerical"
                ]
            }
        }()
        
        // This computed constant maps NSManagedObject attributes to the correct display value
        let quantityTypeMap: [String : String] = {
            if selectedExercise?.exerciseType == "reps" {
                return [
                    "numerical" : "Numerical",
                    "maxperc" : "Percentage of current AMRAP PR"
                ]
            } else {
                return [
                    "maxperc" : "Percentage of current TimeMax PR" ,
                    "numerical" : "Numerical"
                ]
            }
        }()
        
        // Computed variable for the load placeholder
        var loadPlaceholder: String {
            switch editedLoadType {
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
            switch editedQuantityType {
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
        
        /* This dictionary maps the entered value from
         the view to the correct core data property value */
        let typeMap: [String : String] = [
            "Numerical" : "numerical",
            "Percentage of current 1RM PR" : "maxperc",
            "Percentage of current TimeMax PR" : "maxperc",
            "Percentage of current AMRAP PR" : "maxperc",
            "Percentage of current body weight" : "bwperc"
        ]
        
        ScrollView {
            VStack {
                
                BoldTitle(text: "Editing: \(selectedTemplateSet!.timePeriodName!)")
                    .padding(.bottom, 10)
                
                if showSetChangedAlert {
                    SubmitAlert(message: "Successfully edited set!", color: .green, showAlertState: $showSetChangedAlert)
                } else if showNoChangeAlert {
                    SubmitAlert(message: "No change!", color: .blue, showAlertState: $showNoChangeAlert)
                }
                
                LightSubHeadline(text: "Change name or description")
                
                InputShortTextField(
                    placeHolder: "New set name",
                    text: $editedSetName,
                    markAsWrong: $editedSetNameIsInvalid,
                    width: 0.6,
                    errorMessage: $editedSetNameIsInvalidMsg
                )
                .padding(.bottom, 5)
                
                InputShortTextField(
                    placeHolder: "New set description",
                    text: $editedSetDesc,
                    markAsWrong: $editedSetDescIsInvalid,
                    width: 0.6,
                    errorMessage: $editedSetDescIsInvalidMsg
                )
                .padding(.bottom, 20)
                
                #warning("TODO: Implement navigation to ThresholdView")
                
                LightSubHeadline(text: "Change position of the set in it's session")
                
                IntSelectionList(
                    selected: $editedSetPositionIndex,
                    selections: positionIndexes
                )
                .onAppear(perform: {
                    editedSetPositionIndex = selectedTemplateSet!.positionIndex
                })
                .padding(.bottom, 20)
                
                LightSubHeadline(text: "Change the exercise of the set")
                
                SetExerciseSelectionList(
                    selectedExercise: $selectedExercise,
                    searchWord: $searchWord
                )
                .onAppear(perform: {
                    selectedExercise = selectedTemplateSet!.exercise!
                })
                .padding(.bottom, 20)
                
                LightSubHeadline(text: "Change the load type of the set")
                
                StringSelectionList(
                    selected: $editedLoadType,
                    selections: loadTypeSelections
                )
                .onAppear(perform: {
                    editedLoadType = loadTypeMap[selectedTemplateSet!.loadType!]!
                })
                .padding(.bottom, 20)
                
                LightSubHeadline(text: "Change the quantity type of the set")
                
                StringSelectionList(
                    selected: $editedQuantityType,
                    selections: quantityTypeSelections
                )
                .onAppear(perform: {
                    editedQuantityType = quantityTypeMap[selectedTemplateSet!.quantityType!]!
                })
                .padding(.bottom, 20)
                
                LightSubHeadline(text: "Change the quantity or load of the set")
                
                HStack {
                    InputDecimalNumberField(
                        placeHolder: loadPlaceholder,
                        numberText: $editedSetLoad,
                        markAsWrong: $editedSetLoadIsInvalid,
                        width: 0.6,
                        errorMessage: $editedSetLoadIsInvalidMsg
                    )
                    
                    if loadPlaceholder == "Percentage" {
                        Text("%")
                    }
                }
                
                if selectedExercise?.exerciseType == "reps" {
                    HStack {
                        InputIntegerNumberField(
                            placeHolder: quantityPlaceholder,
                            numberText: $editedSetQuantity,
                            markAsWrong: $editedSetQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $editedSetQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        
                        if quantityPlaceholder == "Percentage" {
                            Text("%")
                        }
                    }
                } else {
                    HStack {
                        InputDecimalNumberField(
                            placeHolder: quantityPlaceholder,
                            numberText: $editedSetQuantity,
                            markAsWrong: $editedSetQuantityIsInvalid,
                            width: 0.6,
                            errorMessage: $editedSetQuantityIsInvalidMsg
                        )
                        .padding(.top, 5)
                        if quantityPlaceholder == "Percentage" {
                            Text("%")
                        }
                    }
                }
                
                Button {
                    if validateInput() {
                        
                        func resetView() {
                            withAnimation {
                                editedSetName = ""
                                editedSetDesc = ""
                                editedSetLoad = ""
                                editedSetQuantity = ""
                                showSetChangedAlert = true
                            }
                        }
                        
                        let nameHasChanged = (editedSetName != selectedTemplateSet!.timePeriodName)
                        let descHasChanged = (editedSetDesc != selectedTemplateSet!.timePeriodDescription)
                        let loadHasChanged = (Double(editedSetLoad) ?? selectedTemplateSet!.setLoad != selectedTemplateSet!.setLoad)
                        let quantityHasChanged = (Double(editedSetQuantity) ?? selectedTemplateSet!.setQuantity != selectedTemplateSet!.setQuantity)
                        let exerciseHasChanged = (selectedExercise!.exerciseName != selectedTemplateSet!.exercise!.exerciseName)
                        let loadTypeHasChanged = (typeMap[editedLoadType] != selectedTemplateSet!.loadType)
                        let quantityTypeHasChanged = (typeMap[editedQuantityType] != selectedTemplateSet!.quantityType)
                        let positionIndexHasChanged = (editedSetPositionIndex != selectedTemplateSet!.positionIndex)
                        
                        
                        if !nameHasChanged && !descHasChanged && !exerciseHasChanged && !loadTypeHasChanged && !quantityTypeHasChanged && !positionIndexHasChanged {
                            withAnimation {
                                showNoChangeAlert = true
                                return
                            }
                        }
                        
                        if nameHasChanged {
                            selectedTemplateSet!.timePeriodName = editedSetName
                            resetView()
                        }
                        
                        if descHasChanged {
                            selectedTemplateSet!.timePeriodDescription = editedSetDesc
                            resetView()
                        }
                        
                        if loadHasChanged {
                            selectedTemplateSet!.setLoad = Double(editedSetLoad)!
                            resetView()
                        }
                        
                        if quantityHasChanged {
                            selectedTemplateSet!.setQuantity = Double(editedSetQuantity)!
                            resetView()
                        }
                        
                        if exerciseHasChanged {
                            selectedTemplateSet!.exercise = selectedExercise
                            resetView()
                        }
                        
                        if loadTypeHasChanged {
                            selectedTemplateSet!.loadType = typeMap[editedLoadType]!
                            resetView()
                        }
                        
                        if quantityTypeHasChanged {
                            selectedTemplateSet!.quantityType = typeMap[editedQuantityType]!
                            resetView()
                        }
                        
                        if positionIndexHasChanged {
                            selectedTemplateSet!.positionIndex = editedSetPositionIndex
                            resetView()
                        }
                        
                    }
                } label: {
                    Text("Save changes")
                        .frame(height: 40)
                    Image(systemName: "square.and.arrow.down")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 20)
                
            }
        }
    }
    
    private func validateInput() -> Bool {
        let exerciseType = selectedExercise!.exerciseType
        let quantityValidator: InputFieldValidator
        if exerciseType == "reps" {
            quantityValidator = IntFieldValidator(emptyAllowed: true)
        } else {
            quantityValidator = DoubleFieldValidator(emptyAllowed: true)
        }
        let loadValidator = DoubleFieldValidator(emptyAllowed: true)
        let nameValidator = StringFieldValidator(emptyAllowed: true)
        let descValidtor = StringFieldValidator(emptyAllowed: true)
        
        var valid = 0
        
        valid += loadValidator.valideField(
            inputVar: editedSetLoad,
            errorMessage: $editedSetLoadIsInvalidMsg,
            fieldInvalid: $editedSetLoadIsInvalid
        )
        
        valid += quantityValidator.valideField(
            inputVar: editedSetQuantity,
            errorMessage: $editedSetQuantityIsInvalidMsg,
            fieldInvalid: $editedSetQuantityIsInvalid
        )
        
        valid += nameValidator.valideField(
            inputVar: editedSetName,
            errorMessage: $editedSetNameIsInvalidMsg,
            fieldInvalid: $editedSetNameIsInvalid
        )
        
        valid += descValidtor.valideField(
            inputVar: editedSetDesc,
            errorMessage: $editedSetDescIsInvalidMsg,
            fieldInvalid: $editedSetDescIsInvalid
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
