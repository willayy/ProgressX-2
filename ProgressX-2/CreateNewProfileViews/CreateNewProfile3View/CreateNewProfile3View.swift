//
//  CreateNewProfile3.swift
//  ProgressX-2
//
//  Created by William Norland on 2024-04-22.
//

import SwiftUI

struct CreateNewProfile3View: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    @Binding var navPath: [Int]
    
    /* Fetch BodyEntries so it can be modified by the input values
     At this state in the app there will only be one BodyEntry, the first one. */
    @FetchRequest(
        entity: BodyEntry.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \BodyEntry.achievedOnDate, ascending: true)]
    ) private var bodyEntries: FetchedResults<BodyEntry>
    
    @StateObject private var viewModel = CreateNewProfile3ViewModel()
    
    var body: some View {
        
        // Staticly fetch units
        let circumferenceUnit = PersistenceController.getLengthUnit(viewContext)!
        
        // Input form for PR's on some common exercises
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center, spacing: 10) {
                
                Text("Extra information on body measurements")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                Text("Please fill in all the following fields of measurements for specific body parts, this is only your initial measurements. You can continue to add measurements when weighing-in in the future.")
                    .font(.subheadline)
                    .fontWeight(.light)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
                    .minimumScaleFactor(viewModel.minScaleFactor);
                
                // Inputs for body measurements
                VStack(alignment: .center, spacing: 10) {
                    
                    Text("Circumference metrics")
                        .font(.headline)
                    
                    HStack() {
                        Text("Chest circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        InputDecimalNumberField(
                            placeHolder: circumferenceUnit,
                            numberText: $viewModel.chestCirc,
                            markAsWrong: $viewModel.chestCircIsInvalid,
                            width: viewModel.inputFieldWidth,
                            errorMessage: $viewModel.chestCircIsInvalidMsg
                        )
                    }
                    HStack() {
                        Text("Waist circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        InputDecimalNumberField(
                            placeHolder: circumferenceUnit,
                            numberText: $viewModel.waistCirc,
                            markAsWrong: $viewModel.waistCircIsInvalid,
                            width: viewModel.inputFieldWidth,
                            errorMessage: $viewModel.waistCircIsInvalidMsg
                        )
                    }
                    HStack() {
                        Text("Thigh circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        InputDecimalNumberField(
                            placeHolder: circumferenceUnit,
                            numberText: $viewModel.thighCirc,
                            markAsWrong: $viewModel.thighCircIsInvalid,
                            width: viewModel.inputFieldWidth,
                            errorMessage: $viewModel.thighCircIsInvalidMsg
                        )
                    }
                    HStack() {
                        Text("Calf circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        InputDecimalNumberField(
                            placeHolder: circumferenceUnit,
                            numberText: $viewModel.calfCirc,
                            markAsWrong: $viewModel.calfCircIsInvalid,
                            width: viewModel.inputFieldWidth,
                            errorMessage: $viewModel.calfCircIsInvalidMsg
                        )
                    }
                    HStack() {
                        Text("Lower arm circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        InputDecimalNumberField(
                            placeHolder: circumferenceUnit,
                            numberText: $viewModel.lowerArmCirc,
                            markAsWrong: $viewModel.lowerArmCircIsInvalid,
                            width: viewModel.inputFieldWidth,
                            errorMessage: $viewModel.lowerArmCircIsInvalidMsg
                        )
                    }
                    HStack() {
                        Text("Upper arm circumference")
                            .minimumScaleFactor(viewModel.minScaleFactor)
                            .frame(width: viewModel.textWidth)
                        InputDecimalNumberField(
                            placeHolder: circumferenceUnit,
                            numberText: $viewModel.upperArmCirc,
                            markAsWrong: $viewModel.upperArmCircIsInvalid,
                            width: viewModel.inputFieldWidth,
                            errorMessage: $viewModel.upperArmCircIsInvalidMsg
                        )
                    }
                    
                }
                .padding(.top, 40)
                
                Button {
                    if validateInput() {
                        viewModel.addExtraInfo(viewContext: viewContext, bodyEntries: bodyEntries)
                        navPath.append(3)
                    }
                } label: {
                    Text("Continue")
                        .frame(width: 100, height: 30)
                }
                .buttonStyle(.borderedProminent)
                .padding(.top, 40)
                
            }
        }
    }
    
    // Function for validtaing input fields, in the future, remake InputFieldvalidator to an object that has a set min/max etc and make the inputFields tagged so it can decide itself
    private func validateInput() -> Bool {
        var valid: Int = 0
        let doubleFieldValidator = DoubleFieldValidator()
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.chestCirc,
            errorMessage: $viewModel.chestCircIsInvalidMsg,
            fieldInvalid: $viewModel.chestCircIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.waistCirc,
            errorMessage: $viewModel.waistCircIsInvalidMsg,
            fieldInvalid: $viewModel.waistCircIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.thighCirc,
            errorMessage: $viewModel.thighCircIsInvalidMsg,
            fieldInvalid: $viewModel.thighCircIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.calfCirc,
            errorMessage: $viewModel.calfCircIsInvalidMsg,
            fieldInvalid: $viewModel.calfCircIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.upperArmCirc,
            errorMessage: $viewModel.upperArmCircIsInvalidMsg,
            fieldInvalid: $viewModel.upperArmCircIsInvalid
        )
        
        valid += doubleFieldValidator.valideField(
            inputVar: viewModel.lowerArmCirc,
            errorMessage: $viewModel.lowerArmCircIsInvalidMsg,
            fieldInvalid: $viewModel.lowerArmCircIsInvalid
        )
        
        return valid == 0
    }
    
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    
    @State var navPath = [Int]()
    
    return CreateNewProfile3View(navPath: $navPath)
       .environment(\.managedObjectContext, context)
}
