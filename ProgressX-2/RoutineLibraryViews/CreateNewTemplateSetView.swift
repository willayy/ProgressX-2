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
    private let loadTypeSegments: [String] = ["Numerical", "Percentage"]
    @State var selectedLoadTypeSegment: String = "Numerical"
    
    // Sub-selection of load types
    private let percentageTypeSegments: [String] = ["Current PR load", "Body weight"]
    @State var selectedPercentageTypeSegment: String = "Current 1RM PR"
    
    // Selection of quantity types
    private let quantityTypeSegments: [String] = ["Numerical", "Percentage"]
    @State var selectedQuantityTypeSegment: String = "Numerical"
    
    @Binding var selectedTemplateSession: TemplateSession?
    
    var body: some View {
        
        // Computed variable for the load placeholder
        // Looks horrible i know
        var loadPlaceholder: String {
            if selectedLoadTypeSegment == "Numerical" {
                let weightUnit = PersistenceController.getWeightUnit(viewContext)!
                return "Load (\(weightUnit))"
            } else {
                if selectedPercentageTypeSegment == "Body weight" {
                    return "Percentage of current body weight"
                } else if selectedExercise?.exerciseType == "reps" {
                    return "Percentage of current 1RM"
                } else {
                    return "Percentage of current TimeMax load"
                }
            }
        }
        
        // Computed variable for the quantity placeholder
        // Looks horrible i know
        var quantityPlaceholder: String {
            if selectedQuantityTypeSegment == "Numerical" {
                if selectedExercise?.exerciseType == "reps" {
                    return "Quantity (reps)"
                } else {
                    return "Quantity (seconds)"
                }
            } else {
                if selectedExercise?.exerciseType == "reps" {
                    return "Percentage of current AMRAP"
                } else {
                    return "Percentage of current TimeMax time"
                }
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
                
                BoldSubHeadline(text: "Choose load type")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                
                if selectedLoadTypeSegment == "Numerical" {
                    LightSubHeadline(text: "Numerical load type means that the load will be a numerical value like 100 kg's or 200 lbs")
                        .padding(.horizontal, 20)
                } else {
                    LightSubHeadline(text: "Percentage load type means that the load will be a percentage value like, 90% of my current 1RM PR on this exercise or 110% of my current bodyweight")
                        .padding(.horizontal, 20)
                }
                
                BasicSegPicker(
                    selectedSegment: $selectedLoadTypeSegment,
                    segments: loadTypeSegments,
                    frameWidth: 300,
                    horizontalPadding: 30
                )
                
                if selectedLoadTypeSegment == "Percentage" {
                    BasicSegPicker(
                        selectedSegment: $selectedPercentageTypeSegment,
                        segments: percentageTypeSegments,
                        frameWidth: 300,
                        horizontalPadding: 30
                    )
                    .padding(.top, 5)
                }
                
                BoldSubHeadline(text: "Choose quantity type")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                
                if selectedQuantityTypeSegment == "Numerical" {
                    LightSubHeadline(text: "Numerical quantity type means that the quantity will be a numerical value like 10 seconds or 5 reps.")
                        .padding(.horizontal, 20)
                } else {
                    LightSubHeadline(text: "Percentage quantity type means that the quantity will be a percentage of the current AMRAP/TimeMax PR")
                        .padding(.horizontal, 20)
                }
                
                BasicSegPicker(
                    selectedSegment: $selectedQuantityTypeSegment,
                    segments: quantityTypeSegments,
                    frameWidth: 300,
                    horizontalPadding: 30
                )
                
                BoldSubHeadline(text: "Choose quantity and load")
                    .padding(.top, 20)
                    .padding(.bottom, 5)
                
                // MARK: Load
                HStack {
                    InputDecimalNumberField(
                        placeHolder: loadPlaceholder,
                        numberText: $setLoad,
                        markAsWrong: $setLoadIsInvalid,
                        width: 0.6,
                        errorMessage: $setLoadIsInvalidMsg
                    )
                    
                    if selectedLoadTypeSegment == "Percentage" {
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
                        if selectedQuantityTypeSegment == "Percentage" {
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
                        if selectedQuantityTypeSegment == "Percentage" {
                            Text("%")
                        }
                    }
                }
                
                Button {
                    navPath.append(9)
                } label: {
                    Text("Add new set")
                        .frame(height: 40)
                    Image(systemName: "plus")
                }
                .buttonStyle(BorderedProminentButtonStyle())
                .padding(.top, 10)
                
            }
        }
    }
}

#Preview {
    
    let context = PersistenceController.preview.container.viewContext
    
    let fetchReqeust: NSFetchRequest = TemplateSession.fetchRequest()
    let templateSessions = PersistenceController.fetch(context, fetchRequest: fetchReqeust)
    
    @State var selectedTemplateSession: TemplateSession? = templateSessions.first
    
    return CreateNewTemplateSetView(
        selectedTemplateSession: $selectedTemplateSession
    ).environment(\.managedObjectContext, context)
}
